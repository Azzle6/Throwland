namespace Items.Throwable
{
    using UnityEngine;
    
    public class Projectile : Throwable
    {
        public int Damage;
        
        public override void OnEndThrow()
        {
            throw new System.NotImplementedException();
        }

        public override void OnCollide(Collider2D col)
        {
            throw new System.NotImplementedException();
        }
    }
}