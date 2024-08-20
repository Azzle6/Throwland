using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScreenspaceFollowerUI : MonoBehaviour
{
    public Vector3 offset = Vector3.zero;
    public Transform TargetTransform { get; private set; }
    public Vector3 TargetVector { get; private set; }
    Camera cam;

    private void Awake()
    {
        cam = Camera.main;
    }

    public void SetTarget(Transform target)
    {
        this.TargetTransform = target;
        ScreenspaceFollowerUITarget uiTarget = target.GetComponentInChildren<ScreenspaceFollowerUITarget>();
        if (uiTarget == null)
        {
            return;
        }

        this.TargetTransform= uiTarget.transform;
    }
    public void SetTarget(Vector3 target)
    {
        this.TargetVector = target;
    }

    private void LateUpdate()
    {
        UpdatePos();
    }

    public void UpdatePos()
    {
        if (!cam) return;

        Vector3 targetPos = TargetTransform ? TargetTransform.position : TargetVector;

        if (Vector3.Dot(cam.transform.forward, (targetPos - cam.transform.position).normalized) < 0) transform.position = new Vector3(-500, -500, 0);
        else transform.position = cam.WorldToScreenPoint(targetPos + offset);
    }

    public Vector3 ScreenPosition(Vector3 worldpos)
    {
        return cam.WorldToScreenPoint(worldpos + offset);
    }
}