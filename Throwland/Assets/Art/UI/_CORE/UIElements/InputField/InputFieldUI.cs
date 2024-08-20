using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using System;

public class InputFieldUI : MonoBehaviour
{
    public TMP_InputField InputField { get; private set; }
    public string Text
    {
        get
        {
            return InputField.text;
        }

        set
        { 
            InputField.text = value; 
        }
    }

    private void Awake()
    {
        InputField = GetComponentInChildren<TMP_InputField>();
    }

    public void SetValue(string value)
    {
        InputField.text = value;
    }
}
