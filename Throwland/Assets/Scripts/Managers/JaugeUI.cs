using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

public class JaugeUI : MonoBehaviour
{
    public UnityEvent onComplete;
    Image fill;
    private void Awake()
    {
         fill = GetComponent<Image>();
    }
    bool isCoolingdown;
    float cdProgress;
    float cdDuration;
    public void StartCooldown(float duration)
    {
        cdProgress = 0f;
        isCoolingdown = true;
        cdDuration = duration;
    }

    private void Update()
    {
        if (!isCoolingdown) return;
        cdProgress += Time.deltaTime / cdDuration;

        fill.fillAmount = cdProgress;

        if (cdProgress > 1f)
        {
            isCoolingdown = false;
            onComplete?.Invoke();
        }
    }
}
