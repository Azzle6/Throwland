using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SmoothlyFollowParentUI : MonoBehaviour
{
    public float lerp = 0.2f;
    Transform parent;
    private void Awake()
    {
        parent = transform.parent;
    }

    private void Update()
    {
        transform.position = Vector3.Lerp(transform.position, parent.position, lerp);
    }
}
