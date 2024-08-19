using UnityEngine;
using UnityEngine.Audio;

[CreateAssetMenu(fileName = "SoundListSO", menuName = "SoundTool/SoundListSO", order = 0)]
public class SoundsListSO : ScriptableObject
{
    public SoundInfo[] sounds;
    public SoundSO[] soundS;
    public SoundInfo FindSound(string soundName)
    {
        foreach (SoundInfo s in sounds)
        {
            if (s.clipName == soundName) return s;
        }
        
        return null;
    }

    public SoundSO FindSoundS(string soundName)
    {
        foreach (SoundSO s in soundS)
        {
            if (s.soundName == soundName) return s;
        }

        return null;
    }
    /*[ContextMenu("Generate Sound")]
    public void GenerateSound()
    {
        foreach(SoundInfo s in sounds)
        {
            SoundSO asset = ScriptableObject.CreateInstance<SoundSO>();
            string nameSO = "SFX_" + s.clipName + "_SO";
            asset.soundName = s.clipName;
            asset.soundInfo = s;

            AssetDatabase.CreateAsset(asset, "Assets/SoundTool/Scriptables/Sounds/"+ nameSO + ".asset");
            AssetDatabase.SaveAssets();
        }
        
    }*/
}




