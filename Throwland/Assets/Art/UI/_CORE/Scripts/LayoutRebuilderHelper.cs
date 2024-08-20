using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LayoutRebuilderHelper : MonoBehaviour
{
    private void Awake()
    {
        Canvas.willRenderCanvases += WillRenderCanvases;
    }

    private void OnDestroy()
    {
        Canvas.willRenderCanvases -= WillRenderCanvases;
    }

    private void WillRenderCanvases()
    {
        if (!shouldRebuild) return;
        shouldRebuild = false;
        LayoutRebuilder.ForceRebuildLayoutImmediate(GetComponent<RectTransform>());
    }

    bool shouldRebuild;
    //[Sirenix.OdinInspector.Button]
    public void Rebuild()
    {
        shouldRebuild = true;
    }
}
