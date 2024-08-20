using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CanvasGroupHandler : MonoBehaviour
{
    public bool Visible;
    CanvasGroup group;

    private void Awake()
    {
        group = GetComponent<CanvasGroup>();
        SetVisible(Visible);
    }

    public void SetVisible(bool visible)
    {
        Visible = visible;
        group.alpha = Visible ? 1 : 0f;
        group.blocksRaycasts = Visible;
        group.interactable = Visible;
    }
}
