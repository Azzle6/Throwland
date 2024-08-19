using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

public class SoundManager : MonoBehaviour
{
    public static SoundManager instance;
    [SerializeField] SoundsListSO musicList, soundList;
    Dictionary<SoundInfo, List<AudioSource>> audioList = new Dictionary<SoundInfo, List<AudioSource>>();
    [SerializeField] AudioMixer mainMixer;
    private void Awake()
    {
        if (!instance)
        {
            DontDestroyOnLoad(gameObject);
            instance = this;
        }   
        else if (instance != this)
        {
            Destroy(gameObject);
            return;
        }    

        InitializeSounds();
    }

    void InitializeSounds()
    {
        foreach(SoundInfo s in musicList.sounds)
        {
            AudioSource aS = AddAudioSource(s);
            audioList.Add(s, new List<AudioSource> { aS });
        }

        foreach (SoundInfo s in soundList.sounds)
        {
            AudioSource aS = AddAudioSource(s);
            audioList.Add(s, new List<AudioSource> { aS });
        }
    }

    public void PlaySound(string name, bool play = true )
    {
        SoundInfo s = soundList.FindSound(name);
        if (s == null)
            return;

        if (play)
        {
            int index = 0;
            for(int i  =0; i < audioList[s].Count; i++)
            {
                if(audioList[s][index].isPlaying)
                    index++;
            }
            if(index >= (audioList[s].Count-1))
                audioList[s].Add(AddAudioSource(s));

            audioList[s][index].pitch = 1+Random.Range(s.minPitch, s.maxPitch);
            audioList[s][index].Play();
        }
        else
        {
            int index = audioList[s].Count;
            for(int i = audioList[s].Count; i > 0; i--)
            {
                index--;
                if (audioList[s][index].isPlaying)
                {
                    audioList[s][index].Stop();
                    return;
                }
                    
            }
            
        }
            
    }
    public void PlaySoundOnce(string name, float delay = 0)
    {
        SoundInfo s = soundList.FindSound(name);
        if (s == null)
            return;
        StartCoroutine(PlaySoundOnceDelay(s, delay));
    }
    IEnumerator PlaySoundOnceDelay(SoundInfo s, float delay)
    {
        yield return new WaitForSeconds(delay);
        audioList[s][0].pitch = 1 + Random.Range(s.minPitch, s.maxPitch);
        audioList[s][0].PlayOneShot(s.clip);
    }
    public void PlayMusic(string name, bool play = true)
    {
        SoundInfo s = musicList.FindSound(name);
        if (s == null)
            return;

        if (play)
            audioList[s][0].Play();
        else
            audioList[s][0].Stop();
    }

    public void SetSFXVolume(float value)
    {
        value = Mathf.Clamp(value, 0.0001f, 1);
        mainMixer?.SetFloat("SFXVolume", Mathf.Log10(value) * 20);
    }
    public void SetMusicVolume(float value)
    {
        value = Mathf.Clamp(value, 0.0001f, 1);
        mainMixer?.SetFloat("MusicVolume", Mathf.Log10(value) * 20);
    }
    public void SetMasterVolume(float value)
    {
        value = Mathf.Clamp(value, 0.0001f, 1);
        mainMixer?.SetFloat("MasterVolume", Mathf.Log10(value) * 20);
    }

    AudioSource AddAudioSource(SoundInfo s)
    {
        AudioSource aS = gameObject.AddComponent<AudioSource>();
        aS.outputAudioMixerGroup = s.audioMixerGroup;
        aS.clip = s.clip;
        aS.volume = s.clipVolume;
        aS.pitch = 1;
        aS.loop = s.loop;

        return aS;
    }

}
