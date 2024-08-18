using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleCollisionSpawner : MonoBehaviour
{
    public ParticleSystem ParticleSystem;
    public List<ParticleCollisionEvent> CollisionEvents = new List<ParticleCollisionEvent>();
    public GameObject prefab;

    public Vector3 scale = Vector3.one;

    public Action<GameObject> onSpawned;

    public void OnParticleCollision(GameObject other)
    {
       int numColl =  ParticleSystem.GetCollisionEvents(other, CollisionEvents);

        if (numColl == 0) return;

        foreach (var collision in CollisionEvents)
        {
            Debug.DrawLine(collision.intersection, collision.intersection + collision.normal * 2f, Color.yellow, 2f);

            GameObject go = Instantiate(prefab, collision.intersection, Quaternion.LookRotation(collision.normal) * Quaternion.AngleAxis(UnityEngine.Random.Range(0f,360f), Vector3.forward));
            go.transform.localScale = scale;

            onSpawned?.Invoke(go);
        }
    }
}
