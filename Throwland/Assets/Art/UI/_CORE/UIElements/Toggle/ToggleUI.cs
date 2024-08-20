using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ToggleUI : MonoBehaviour
{
    public Toggle Toggle;
    public bool Value => Toggle.isOn;

    private void Awake()
    {
        Toggle.onValueChanged.AddListener(OnValueChanged);
    }

    public Action onValueChanged;
    private void OnValueChanged(bool value)
    {
        onValueChanged?.Invoke();
    }

    public void SetValue(bool value)
    {
        Toggle.isOn = value;
    }
}
