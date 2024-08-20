using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Singleton<T> : MonoBehaviour where T: Component
{
    protected static T instance;
    public static T Instance
    { 
        get 
        { 
            if (instance == null) instance = FindFirstObjectByType<T>(FindObjectsInactive.Include);
            return instance;
        } 
    }
}