using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using UnityEngine;
using UnityEngine.UI;

public class SliderUI : MonoBehaviour
{
    public string inputFieldPrecision = "F2";
    Slider slider;
    InputFieldUI inputField;
    public float Value
    {
        get
        {
            return slider.value;
        }
        set
        {
            slider.value = value;
        }
    }

    private void Start()
    {
        slider = GetComponentInChildren<Slider>();
        inputField = GetComponentInChildren<InputFieldUI>();
        if (inputField) inputField.InputField.onEndEdit.AddListener(OnFieldValueChanged);
        slider.onValueChanged.AddListener(OnSliderValueChanged);
        OnSliderValueChanged(slider.value);
    }

    public Action onValueChanged;
    private void OnSliderValueChanged(float newValue)
    {
        RefreshInputField();
        onValueChanged?.Invoke();
    }

    private void RefreshInputField()
    {
        if (inputField == null) return;
        inputField.SetValue(slider.value.ToString(inputFieldPrecision));
    }

    private void OnFieldValueChanged(string text)
    {
        string value = inputField.Text;
        float outputValue;
        bool success = float.TryParse(value, NumberStyles.Float, CultureInfo.InvariantCulture, out outputValue);
        if (success)
        {
            slider.value = outputValue;
        }

        else
        {
            RefreshInputField();
        }
    }

    public void SetRange(float min, float max)
    {
        if(slider == null) slider = GetComponentInChildren<Slider>();
        slider.minValue = min;
        slider.maxValue = max;
    }

    public void SetValue(float value)
    {
        slider.value = value;
        RefreshInputField();
    }
}
