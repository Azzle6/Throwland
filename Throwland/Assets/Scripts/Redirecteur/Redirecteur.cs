using Items.Throwable;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace Items.Buildings
{
    public class Redirecteur : Building
    {
        [Header("View")]
        [SerializeField] SpriteRenderer influenceCircle;

        [Header("Parameters")]
        [SerializeField] float lifeTime;
        [SerializeField] float radius;
        [SerializeField] LayerMask collisionMask;
        public enum RedirectType { ATTRACT, REPULSE, ORIENT, ACCEL, SLOW }
        [SerializeField] RedirectType redirectType;
        [SerializeField] float force;

        public override E_BuildingType BuildingType => E_BuildingType.REDIRECTOR;

        private void Update()
        {
            lifeTime -= Time.deltaTime;
            if (lifeTime < 0)
            {
                Destroy(gameObject);
            }
        }
        private void FixedUpdate()
        {
            influenceCircle.transform.localScale = Vector3.one * radius * 2;
            var hits = Physics2D.OverlapCircleAll(transform.position, radius, collisionMask);
            if (hits.Length == 0) return;
            foreach (var hit in hits)
            {
                ThrowableBuilding throwableBuilding = hit.GetComponent<ThrowableBuilding>();
                if (throwableBuilding == null) continue;

                Vector2 dir = Vector2.zero;
                switch (redirectType)
                {
                    case RedirectType.ATTRACT:
                        {
                            dir = (transform.position - hit.transform.position).normalized;
                            break;
                        }
                    case RedirectType.REPULSE:
                        {
                            dir = (hit.transform.position - transform.position).normalized;
                            break;
                        }

                    case RedirectType.ORIENT:
                        {
                            dir = transform.right;
                            break;
                        }
                    case RedirectType.ACCEL:
                        {
                            dir = throwableBuilding.velocity.normalized;
                            break;
                        }
                    case RedirectType.SLOW:
                        {
                            dir -= throwableBuilding.velocity.normalized;
                            break;
                        }

                }
                Vector3 force = dir * this.force;
                if (redirectType != RedirectType.ORIENT)
                    throwableBuilding.AddForce(force);
                else
                {
                    var length = throwableBuilding.velocity.magnitude;
                    throwableBuilding.velocity = length * dir;
                }
            }

        }
    }
}



