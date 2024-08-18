using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomSpriteFlip : MonoBehaviour
{
    private void Awake()
    {
        SpriteRenderer renderer = GetComponent<SpriteRenderer>();
        if (renderer == null) return;

        renderer.flipX = Random.Range(0f, 1f) > 0.5f;
    }
}
