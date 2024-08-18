using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class TextVFX : MonoBehaviour
{
    public void Initialize(string text)
    {
        TextMeshPro textMesh =GetComponentInChildren<TextMeshPro>(); 
        textMesh.text = text;
    }
}
