using Helpers;
using Resources;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Ressource_UI : MonoBehaviour
{
    [SerializeField] Image Icon;
    [SerializeField] TextMeshProUGUI textMeshProUGUI;
    [SerializeField] RessourceIconDictionary iconDictionary = new RessourceIconDictionary();
    public void UpdateView(ResourceQuantity resourceQuantity)
    {
        if(iconDictionary.ContainsKey(resourceQuantity.ResourceType))
            Icon.sprite = iconDictionary[resourceQuantity.ResourceType];
        else Icon.sprite = null;
        textMeshProUGUI.text = resourceQuantity.Quantity.ToString();

    }
}
