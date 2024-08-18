using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SlingerInput : MonoBehaviour
{
    [Header("References")]
    [SerializeField] Projectable ProjectablePrefab;
    [SerializeField] BoxCollider2D slingZone;

    [Header("Visual")]
    [SerializeField] SpriteRenderer startSlingSprite;
    [SerializeField] SpriteRenderer endSlingSprite, lastStartSlingSprite;
    [SerializeField] LineRenderer slingLine;

    [Header("SlingParameter")]
    [SerializeField] float minForce = 5;
    [SerializeField] float maxForce = 50;

    [SerializeField] float minSlingDist = 0.5f;
    [SerializeField] float maxSlingDist = 3f;

    [Header("Ammunition")]
    [SerializeField] List<Projectable> projectables;
    //Sling Parameter
    Vector3 slingVector;
    Vector3 startSlingPosition, endSlingPosition, lastStartSlingPosition;
    

    KeyCode slingInput = KeyCode.Space;
    Camera mainCamera;

    [Header("Debug")]
    [SerializeField] SpriteRenderer debugSprite;

    private void Start()
    {
        mainCamera = Camera.main;
    }
    void Update()
    {

        UpdateSlingParameter();

        if (Input.GetKeyUp(slingInput) && slingZone.OverlapPoint(startSlingPosition) && slingVector != Vector3.zero)
            Launch();
         UpdateSlingVisual();

        // Debug
        debugSprite.color = slingZone.OverlapPoint(mainCamera.ScreenToWorldPoint(Input.mousePosition)) ? Color.green : Color.red;
        var color = new Color(debugSprite.color.r, debugSprite.color.g, debugSprite.color.b, 0.2f);
        debugSprite.color = color;
        startSlingSprite.transform.position = startSlingPosition;
    }
    void UpdateSlingParameter()
    {
        if (Input.GetKeyUp(slingInput))
        {
            lastStartSlingPosition = startSlingPosition;
            slingVector =  startSlingPosition - endSlingPosition;
            endSlingPosition = startSlingPosition;
        }

        if (slingZone.OverlapPoint(mainCamera.ScreenToWorldPoint(Input.mousePosition)) == false) return;
        var mousePosition = mainCamera.ScreenToWorldPoint(Input.mousePosition);
        mousePosition.z = 0;

        if(Input.GetKey(slingInput) == false && Input.GetKeyUp(slingInput) == false) startSlingPosition = mousePosition;
        endSlingPosition = mousePosition;
    }

    void UpdateSlingVisual()
    {
        startSlingSprite.transform.position = startSlingPosition;
        endSlingSprite.transform.position = endSlingPosition;
        lastStartSlingSprite.transform.position = lastStartSlingPosition;

        slingLine.SetPosition(0, startSlingPosition);
        slingLine.SetPosition(1, endSlingPosition);
    }


    void Launch()
    {
        var projectable = Instantiate(ProjectablePrefab, startSlingSprite.transform.position, transform.rotation);

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
