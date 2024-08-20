using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "SoundGroupSO", menuName = "SoundTool/SoundGroupSO", order = 0)]
public class SoundGroupSO : SoundSO
{
    public int weight = 1;
    public SoundGroup[] soundsAdded;
}

[System.Serializable]
public class SoundGroup
{
    public SoundSO sound;
    public int weight = 1 ;
}
