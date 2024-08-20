using System.Collections;
using System.Collections.Generic;
using Items;
using Managers;
using Sirenix.OdinInspector;
using UnityEngine;
using Unity.Netcode;
using UnityEngine.Serialization;

public class Slinger : NetworkBehaviour
{
    [Header("Visual")]
    [SerializeField] SpriteRenderer startSlingSprite;
    [SerializeField] SpriteRenderer endSlingSprite, lastStartSlingSprite;
    [SerializeField] LineRenderer slingLine,previseLine;
    [SerializeField] float previseReduction;
    [SerializeField] private GameObject repairIcon;
    [SerializeField] private TeamColoredSprite spriteColorTeam;

    [Header("SlingParameter")]
    [SerializeField] float minForce = 5;
    [SerializeField] float maxForce = 50;

    [SerializeField] float minSlingDist = 0.5f;
    [SerializeField] float maxSlingDist = 3f;
    [SerializeField] float launchYClamp = 20;

    [SerializeField] float endOrientationSpeed;
    //Sling Parameter
    Vector3 slingVector;
    Vector3 startSlingPosition, endSlingPosition, launchPosition;
    Quaternion endSlingRotation;

    [Header("Ammunition")]
    [SerializeField] List<ScriptableObject> projectablesItem;
    int selectIndex = 0;

    [Header("Input")]
    [SerializeField] KeyCode slingInput = KeyCode.Mouse0;
    [SerializeField] private KeyCode altSlingInput = KeyCode.Mouse1;
    [SerializeField] KeyCode changeItemUp = KeyCode.UpArrow;
    [SerializeField] KeyCode selectItemDown = KeyCode.DownArrow;
    [SerializeField] KeyCode rotateLeft = KeyCode.LeftArrow;
    [SerializeField] KeyCode rotateRight = KeyCode.RightArrow;

    [BoxGroup("Movement"), SerializeField] 
    private float movementSpeed = 1;
    [BoxGroup("Movement")]
    [SerializeField] private KeyCode goLeft = KeyCode.Q;
    [BoxGroup("Movement")]
    [SerializeField] private KeyCode goRight = KeyCode.D;
    [BoxGroup("Movement")]
    [SerializeField] private KeyCode goUp = KeyCode.Z;
    [BoxGroup("Movement")]
    [SerializeField] private KeyCode goDown = KeyCode.S;

    private NetworkVariable<bool> isStun = new NetworkVariable<bool>(false, NetworkVariableReadPermission.Everyone);
    public NetworkVariable<E_ItemOwner> ItemOwner = new NetworkVariable<E_ItemOwner>(E_ItemOwner.PLAYER_1, NetworkVariableReadPermission.Everyone);
    private Coroutine currentStunCoroutine;
    
    private bool canSlingInput = true;

    Camera mainCamera;
    
    public override void OnNetworkSpawn()
    {
        this.startSlingSprite.gameObject.SetActive(IsOwner);
        this.endSlingSprite.gameObject.SetActive(IsOwner);
        this.slingLine.gameObject.SetActive(IsOwner);
        this.previseLine.gameObject.SetActive(IsOwner);
        
        if (IsOwner)
        {
            Debug.Log(GlobalManager.Instance.ClientTeam);

            this.spriteColorTeam.SetTeam((int)GlobalManager.Instance.ClientTeam);
            this.SetOwnerServerRpc(GlobalManager.Instance.ClientTeam);
            
            Vector3 newPos = GlobalManager.Instance.ClientTeam == E_ItemOwner.PLAYER_1
                ? GlobalManager.Instance.FirstSlingerSpawn.position
                : GlobalManager.Instance.SecondSlingerSpawn.position;
            
            ChangePositionServerRpc(newPos);
        }
        this.isStun.OnValueChanged += OnStunValueChanged;
    }

    private void OnStunValueChanged(bool previousvalue, bool newvalue)
    {
        this.repairIcon.SetActive(newvalue);
    }

    [ServerRpc]
    private void SetOwnerServerRpc(E_ItemOwner owner)
    {
        this.ItemOwner.Value = owner;
    }

    [ServerRpc]
    private void ChangePositionServerRpc(Vector3 pos)
    {
        transform.position = pos;
        ChangePositionClientRpc(pos);
    }

    [ClientRpc]
    private void ChangePositionClientRpc(Vector3 pos)
    {
        transform.position = pos;
    }
    
    private void Start()
    {
        mainCamera = Camera.main;
    }
    
    void Update()
    {
        if (!IsOwner)
            return;
        
        UpdateSlingParameter();
        PerformInputs();
        UpdateSlingVisual();
    }
    
    void UpdateSlingParameter()
    {
        // Get Mouse Position
        var mousePosition = mainCamera.ScreenToWorldPoint(Input.mousePosition);
        mousePosition.z = 0;

        //Update launch position

        Vector3 moveDirection = Vector3.zero;
        moveDirection.x = (Input.GetKey(this.goRight) ? this.movementSpeed : 0) - (Input.GetKey(this.goLeft) ? this.movementSpeed : 0);
        moveDirection.y = (Input.GetKey(this.goUp) ? this.movementSpeed : 0) - (Input.GetKey(this.goDown) ? this.movementSpeed : 0);
        moveDirection = Vector3.ClampMagnitude(moveDirection, this.movementSpeed);
        this.transform.position += moveDirection * (Time.deltaTime * (this.isStun.Value ? 0.8f : 1));
        this.launchPosition = this.transform.position;
        
        /*launchPosition = startSlingPosition;
        launchPosition.x = transform.position.x;
        launchPosition.y = Mathf.Clamp(launchPosition.y, transform.position.y - launchYClamp * 0.5f, transform.position.y + launchYClamp * 0.5f);*/

        //Update sling Vector + Reset endOrientation
        if (Input.GetKeyUp(slingInput) || Input.GetKeyUp(this.altSlingInput))
        {
            slingVector =  startSlingPosition - endSlingPosition;
            endSlingPosition = startSlingPosition;
            endSlingRotation = Quaternion.identity;
        }

        // Update end & start sling position
        if(Input.GetKey(slingInput) == false && Input.GetKeyUp(slingInput) == false && Input.GetKey(this.altSlingInput) == false && Input.GetKeyUp(this.altSlingInput) == false) startSlingPosition = mousePosition;
        endSlingPosition = mousePosition;
    }
    void PerformInputs()
    {
        if (Input.GetKeyUp(slingInput) && slingVector != Vector3.zero && this.canSlingInput)
        {
            ThrowLocal("Projectile");
            this.StartCoroutine(this.SlingerCooldown());
            SoundManager.instance.PlaySoundOnce("ShootSlam");
        }
        else if (Input.GetKeyUp(this.altSlingInput) && slingVector != Vector3.zero && this.canSlingInput)
        {
            ThrowLocal("ThrowableCity");
            this.StartCoroutine(this.SlingerCooldown());
            SoundManager.instance.PlaySoundOnce("ShootSlam");
        }
            

        //Update Rotation
        var angleSpeed = 0f;
        if (Input.GetKey(rotateLeft))
            angleSpeed -= endOrientationSpeed * Time.deltaTime;
        if (Input.GetKey(rotateRight))
            angleSpeed += endOrientationSpeed * Time.deltaTime;
        endSlingRotation *= Quaternion.Euler(Vector3.forward * angleSpeed);

        //Update Select Rotation;
        if (Input.GetKeyDown(selectItemDown))
        {
            selectIndex -= 1;
            if (selectIndex < 0)
                selectIndex = projectablesItem.Count - 1;
        }    

        if (Input.GetKeyDown(selectItemDown))
        {
            selectIndex += 1;
            selectIndex %= projectablesItem.Count;
        }
    }
    
    void UpdateSlingVisual()
    {
        startSlingSprite.transform.position = startSlingPosition;
        endSlingSprite.transform.position = endSlingPosition;
        //lastStartSlingSprite.transform.position = launchPosition;

        slingLine.SetPosition(0, startSlingPosition);
        slingLine.SetPosition(1, endSlingPosition);

        previseLine.SetPosition(0,launchPosition);
        var previseVector = ( startSlingPosition - endSlingPosition);
        float slingForceFactor = (previseVector.magnitude - minSlingDist) / (maxSlingDist - minSlingDist);
        float slingForce = Mathf.Lerp(minForce, maxForce, slingForceFactor);
        previseLine.SetPosition(1, launchPosition + previseVector.normalized * slingForce * previseReduction);
    }
    
    void ThrowLocal(string elementToThrow)
    {
        //Vector3 slingDir = (startSlingPosition - endSlingPosition).normalized;
        if(this.isStun.Value)
            return;
        
        float slingForceFactor = (slingVector.magnitude-minSlingDist)/(maxSlingDist-minSlingDist);
        float slingForce = Mathf.Lerp(minForce, maxForce, slingForceFactor);
        GlobalManager.Instance.RequestThrowObjectServerRpc(elementToThrow, this.launchPosition, slingVector.normalized, slingForce, GlobalManager.Instance.ClientTeam);
    }

    [ServerRpc(RequireOwnership = false)]
    public void StunSlingerServerRpc(bool value)
    {
        this.isStun.Value = value;
    }
    
    public void StunSlinger()
    {
        if(this.currentStunCoroutine != null)
            StopCoroutine(this.currentStunCoroutine);
        this.StunSlingerServerRpc(true);
        currentStunCoroutine = StartCoroutine(this.StunCooldown());
    }

    private IEnumerator SlingerCooldown()
    {
        this.canSlingInput = false;
        yield return new WaitForSeconds(1.3f);
        this.canSlingInput = true;
    }
    
    private IEnumerator StunCooldown()
    {
        yield return new WaitForSeconds(6f);
        this.StunSlingerServerRpc(false);
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.yellow;
        Gizmos.DrawSphere(startSlingPosition, 0.5f);
        Gizmos.color = Color.red;
        Gizmos.DrawSphere(endSlingPosition, 0.2f);

        if(mainCamera != null)
        {
            var mousePosition = mainCamera.ScreenToWorldPoint(Input.mousePosition);
            mousePosition.z = 0;

            Gizmos.color = Color.white;
            Gizmos.DrawSphere(mousePosition, 0.1f);
        }

    }
}
