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
        public float dragCoeff;
        public LayerMask terrainMask;
        public LayerMask collisionMask;
        public Quaternion endOrientation;

        public abstract void OnEndThrowServer();

        public abstract void OnCollide(Collider2D col);

        public override void OnHit(int damages)
        {
            Debug.Log("Hit a throwable");
        }

        public void ThrowServer(Vector2 startPosition, Vector2 dir, float strength)
        {
            transform.position = (startPosition);
            velocity = dir * strength;
            acceleration = Vector2.zero;
        }

        private void Update()
        {
            if(!IsOwner)
                return;
            
            lifeTime -= Time.deltaTime;
            if (lifeTime < 0)
            {
                Destroy();
            }

            var hit = Physics2D.OverlapCircle(transform.position, radius, collisionMask);
            if (hit != null)
                OnCollide(hit);
        }

        private void FixedUpdate()
        {
            if(!IsOwner)
                return;
            
            transform.position += (Vector3)velocity * Time.fixedDeltaTime;
            Vector2 dragForce = 0.5f * velocity * dragCoeff; // * velocity.magnitude;
            velocity += (acceleration - dragForce) * Time.fixedDeltaTime;
            acceleration = Vector3.zero;
        }
        public void AddForce(Vector2 force)
        {
            acceleration += force;
        }
  
        
        private void Destroy()
        {
            OnEndThrowServer();
            this.DeleteItemServerRpc();
        }
    }
}