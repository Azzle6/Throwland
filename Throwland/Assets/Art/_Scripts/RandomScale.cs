using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomScale : MonoBehaviour
{
    public float minScale = 0.8f;
    public float maxScale = 1.2f;
    void Start()
    {
        transform.localScale = Vector3.one * Random.Range(minScale, maxScale);
    }

}
