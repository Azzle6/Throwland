using System;

namespace Items.Throwable
{
    using UnityEngine;
    
    [Serializable]
    public abstract class Throwable : Item
    {
        public float radius;
        public Vector2 velocity;
        public Vector2 acceleration; // Gravity as an example
        public float lifeTime;
        public LayerMask terrainMask;
        public LayerMask collisionMask;
        public Quaternion endOrientation;
        public GameObject endPrefab;

        public abstract void OnEndThrow();

        public abstract void OnCollide(Collider2D col);

        public override void OnHit(int damages)
        {
            Debug.Log("Hit a throwable");
        }

        public void Throw(Vector2 startPosition, Vector2 dir, float strength)
        {
            transform.position = startPosition;
            velocity = dir * strength;
            acceleration = Vector2.zero;
        }

        private void Update()
        {
            lifeTime -= Time.deltaTime;
            if (lifeTime < 0)
            {
                Spawn();
                Destroy();
            }

            var hit = Physics2D.OverlapCircle(transform.position, radius, collisionMask);
            if (hit != null)
                OnCollide(hit);
        }

        private void FixedUpdate()
        {
            transform.position += (Vector3)velocity * Time.fixedDeltaTime;
            velocity += acceleration * Time.fixedDeltaTime;
            acceleration = Vector3.zero;
        }
        public void AddForce(Vector2 force)
        {
            acceleration += force;
        }
        private void Spawn()
        {
            if (endPrefab == null) return;
            if (Physics2D.OverlapPoint(transform.position, terrainMask) == null) return;
            var prefabInstance = GameObject.Instantiate(endPrefab, transform.position, endOrientation);
        }
        private void Destroy()
        {
            OnEndThrow();
            Destroy(gameObject); //TODO : Pooler
        }
    }
}