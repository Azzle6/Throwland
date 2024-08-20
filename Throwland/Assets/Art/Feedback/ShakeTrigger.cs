using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShakeTrigger : MonoBehaviour
{
    public ShakeSettings settings;
    public bool CameraShake = true;
    public bool onAwake = true;

    public void Awake()
    {
        if (!onAwake) return;
        StartShake();
    }

    public void StartShake()
    {
        PerformShake();

        //else
        //{
        //    Sequence seq = DOTween.Sequence();
        //    seq.AppendInterval(settings.delay);
        //    seq.OnComplete(PerformShake);
        //}
    }

    private void PerformShake()
    {
        if (CameraShake)
            Camera.main.GetComponentInParent<Shaker>().Shake(settings);
        else
            GetComponent<Shaker>().Shake(settings);
    }
}
