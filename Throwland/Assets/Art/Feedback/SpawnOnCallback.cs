using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnOnCallback : MonoBehaviour
{
    public GameObject onDestroy;
    public GameObject onStart;
    public GameObject onCollide;

    private void OnDestroy()
    {
        Spawn(onDestroy);
        if (SoundManager.instance != null) SoundManager.instance.PlaySoundOnce("Explosion");
    }

    private void Start()
    {
        Spawn(onStart);
    }

    private void OnCollisionEnter(Collision collision)
    {
        Spawn(onCollide);
    }

    private void Spawn(GameObject gameObject)
    {
        if (gameObject == null) return;
        Instantiate(gameObject, transform.position, transform.rotation);
    }
}
