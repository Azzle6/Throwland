using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.Netcode;
public class Slinger : NetworkBehaviour
{
    [Header("References")]
    [SerializeField] Projectable ProjectablePrefab;

    [Header("Visual")]
    [SerializeField] SpriteRenderer startSlingSprite;
    [SerializeField] SpriteRenderer endSlingSprite, lastStartSlingSprite;
    [SerializeField] LineRenderer slingLine,previseLine;
    [SerializeField] float previseReduction;

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
    [SerializeField] KeyCode changeItemUp = KeyCode.UpArrow;
    [SerializeField] KeyCode selectItemDown = KeyCode.DownArrow;
    [SerializeField] KeyCode rotateLeft = KeyCode.LeftArrow;
    [SerializeField] KeyCode rotateRight = KeyCode.RightArrow;

    Camera mainCamera;

    private void Start()
    {
        mainCamera = Camera.main;
    }
    void Update()
    {
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
        launchPosition = startSlingPosition;
        launchPosition.x = transform.position.x;
        launchPosition.y = Mathf.Clamp(launchPosition.y, transform.position.y - launchYClamp * 0.5f, transform.position.y + launchYClamp * 0.5f);

        //Update sling Vector + Reset endOrientation
        if (Input.GetKeyUp(slingInput))
        {
            slingVector =  startSlingPosition - endSlingPosition;
            endSlingPosition = startSlingPosition;
            endSlingRotation = Quaternion.identity;
        }

        // Update end & start sling position
        if(Input.GetKey(slingInput) == false && Input.GetKeyUp(slingInput) == false) startSlingPosition = mousePosition;
        endSlingPosition = mousePosition;
    }
    void PerformInputs()
    {
        if (Input.GetKeyUp(slingInput) && slingVector != Vector3.zero)
            Launch();

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
        lastStartSlingSprite.transform.position = launchPosition;

        slingLine.SetPosition(0, startSlingPosition);
        slingLine.SetPosition(1, endSlingPosition);

        previseLine.SetPosition(0,launchPosition);
        var previseVector = ( startSlingPosition - endSlingPosition);
        float slingForceFactor = (previseVector.magnitude - minSlingDist) / (maxSlingDist - minSlingDist);
        float slingForce = Mathf.Lerp(minForce, maxForce, slingForceFactor);
        previseLine.SetPosition(1, launchPosition + previseVector.normalized * slingForce * previseReduction);
    }


    void Launch()
    {
        var projectable = Instantiate(ProjectablePrefab, launchPosition, transform.rotation);

        Vector3 slingDir = slingVector.normalized;
        float slingForceFactor = (slingVector.magnitude-minSlingDist)/(maxSlingDist-minSlingDist);
        float slingForce = Mathf.Lerp(minForce, maxForce, slingForceFactor);
        projectable.velocity = slingDir * slingForce;
        //projectable.Init(startSlingPosition, 3f, slingForce * slingDir);
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
