using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class ShakeSettings
{
    //public float delay = 0f;
    public float duration = 1f;
    public float intensity = 1f;
    public float frequency = 1f;
    public AnimationCurve curve = new AnimationCurve(
        new Keyframe[]
        {
            new Keyframe(0,1, 0, -2),
            new Keyframe(1,0, 0, -1)
        });
}

public class Shaker : MonoBehaviour
{    
    public ShakeSettings debugSettings;
    bool isShaking = false;
    float shakeProgress = 0f;
    float random;
    
    ShakeSettings currentSettings;
    public void Shake(ShakeSettings settings)
    {
        currentSettings = settings;
        Shake();
    }

    [ContextMenu("Shake")]
    public void Shake()
    {
        if(currentSettings == null) currentSettings = debugSettings;
        isShaking = true;
        shakeProgress = 0f;
        random = UnityEngine.Random.Range(0f, 1f);
    }

    public void Update()
    {
        if(!isShaking) return;
        shakeProgress += Time.deltaTime / currentSettings.duration;

        float curveIntensity = currentSettings.curve.Evaluate(shakeProgress);

        float noiseX = Mathf.PerlinNoise(shakeProgress * currentSettings.frequency * currentSettings.duration, random) * 2 - 1;
        float noiseY = Mathf.PerlinNoise(random, shakeProgress * currentSettings.frequency * currentSettings.duration) * 2 - 1;

        float finalIntensity = currentSettings.intensity * curveIntensity;

        transform.localPosition = new Vector3(noiseX * finalIntensity, noiseY * finalIntensity, 0f);

        if(shakeProgress >= 1)
        {
            isShaking = false;
            transform.localPosition = Vector3.zero;
        }
    }
}
