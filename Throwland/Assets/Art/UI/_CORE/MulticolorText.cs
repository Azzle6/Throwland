using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class MulticolorText : MonoBehaviour
{
    TextMeshProUGUI text;
    public float huePanSpeed = 1f;
    public float saturation = 1f;
    public float value = 1f;

    private void Awake()
    {
        text = GetComponent<TextMeshProUGUI>();
    }

    float hue = 0f;
    private void Update()
    {
        if (text == null) return;
        hue += Time.deltaTime * huePanSpeed;
        hue = hue % 1f;
        Color color = Color.HSVToRGB(hue, saturation, value);
        text.color = color;
    }
}
