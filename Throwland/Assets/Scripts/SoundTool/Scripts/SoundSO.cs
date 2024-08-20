using UnityEngine.Audio;
using UnityEngine;

[CreateAssetMenu(fileName = "SFX_SoundName_SO", menuName = "SoundTool/SoundSO", order = 0)]
public class SoundSO : ScriptableObject
{
    public string soundName;
    public SoundInfo soundInfo;
}

[System.Serializable]
public class SoundInfo
{
    public string clipName;
    public AudioClip clip;
    public AudioMixerGroup audioMixerGroup;
    public bool loop;
    [Range(0, 1)]
    public float clipVolume = 1;
    public float minPitch = -0.1f, maxPitch = 0.1f;

}
