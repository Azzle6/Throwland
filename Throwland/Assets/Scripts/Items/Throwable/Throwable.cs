using System;
using Managers;

namespace Items.Throwable
{
    using UnityEngine;
    
    [Serializable]
    public abstract class Throwable : Item
    {
        [SerializeField] 
        private float weight;
        
        private Vector2 curDirection;
        private float curVelocity;
        private bool isThrowing;
        
        public abstract void OnEndThrow();

        public abstract void OnCollide(Collider col);

        public override void OnHit(int damages)
        {
            Debug.Log("Hit a throwable");
        }

        public void Throw(Vector2 startPosition, Vector2 dir, float strength)
        {
            transform.position = startPosition;
            this.curDirection = dir;
            this.curVelocity = strength;
            this.isThrowing = true;
        }
        
        public override void OnDebugPlace(Vector3 pos, E_ItemOwner owner)
        {
            GlobalManager.Instance.RequestThrowObjectServerRpc(ID, pos, Vector2.up, 1f, this.Owner);
        }

        private void Update()
        {
            if (this.curVelocity > 0)
            {
                transform.position += (Vector3)this.curDirection * (this.curVelocity * Time.deltaTime);
                this.curVelocity -= Time.deltaTime * this.weight;
            }
            else if (this.isThrowing)
            {
                this.OnEndThrow();
                Destroy(this.gameObject);
            }
        }
    }
}