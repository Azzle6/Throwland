using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpriteSorter : MonoBehaviour
{
    SpriteRenderer spriteRenderer;

    private void Awake()
    {
        spriteRenderer = GetComponent<SpriteRenderer>();
        Sort();
    }

    private void Sort()
    {
        if (spriteRenderer == null) return;
        spriteRenderer.sortingOrder = (int)(-transform.position.y * 1000f);
    }
}
