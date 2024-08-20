using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SetUIFloat : MonoBehaviour
{
    public float floatValue = 0f;
    public string propertyName = "_Float";
    Image image;

    Material mat
    {
        get
        {
            if (image == null) image =GetComponent<Image>();
            if (image == null) return null;

            return image.material;
        }
    }

    private void Update()
    {
        ApplyFloat();
    }

    [Sirenix.OdinInspector.OnInspectorGUI]
    void ApplyFloat()
    {
        Material material = mat;
        if(material == null) return;    

        material.SetFloat(propertyName, floatValue);
    }
}
