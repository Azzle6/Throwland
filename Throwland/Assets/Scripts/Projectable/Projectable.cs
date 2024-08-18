using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Projectable : MonoBehaviour
{
    public Vector3 velocity;
    public Vector3 acceleration; // Gravity as an example
    public float lifeTime;

    public Quaternion endOrientation;
    public GameObject endPrefab;
    private void Update()
    {
        lifeTime -= Time.deltaTime;
        if (lifeTime < 0 )
            Destroy();
    }
    public void FixedUpdate()
    {
        transform.position += velocity * Time.fixedDeltaTime;
        velocity += acceleration * Time.fixedDeltaTime;
        acceleration = Vector3.zero;
    }
    public void Init(Vector3 position, float lifeTime, Vector3 initialVelocity)
    {
        transform.position = position;
        velocity = initialVelocity;
    }
    public void AddForce(Vector3 force)
    {
      
        acceleration += force;
    }
    private void Spawn()
    {
        if (endPrefab == null) return;
        if (!Physics2D.OverlapPoint(transform.position,7)) return;
        var prefabInstance = GameObject.Instantiate(endPrefab,transform.position, endOrientation);
    }
    private void Destroy()
    {
        Destroy(gameObject); //TODO : Pooler
    }
}
