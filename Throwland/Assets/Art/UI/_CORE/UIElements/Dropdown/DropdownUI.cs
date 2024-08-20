using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using System;

public class DropdownUI : MonoBehaviour
{
    public int Value => dropdown.value;
    public TMP_Dropdown dropdown;

    private void Awake()
    {
        dropdown.onValueChanged.AddListener(OnValueChanged);
    }

    public Action onValueChanged;
    private void OnValueChanged(int value)
    {
        onValueChanged?.Invoke();
    }

    public void SetValue(int value)
    {
        dropdown.value = value;
    }

    public void SetOptions(List<string> options)
    {
        dropdown.ClearOptions();
        dropdown.AddOptions(options);
    }
}
