using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Redirecteur : MonoBehaviour
{
    [Header("View")]
    [SerializeField] SpriteRenderer influenceCircle;

    [Header("Parameters")]
    [SerializeField] float radius;
    [SerializeField] LayerMask collisionMask;
    public enum RedirectType { ATTRACT,REPULSE,ORIENT,ACCEL,SLOW}
    [SerializeField] RedirectType redirectType;
    [SerializeField] float force;

    private void FixedUpdate()
    {
        influenceCircle.transform.localScale = Vector3.one * radius * 2;
        var hits = Physics2D.OverlapCircleAll(transform.position, radius, collisionMask);
        if(hits.Length == 0 ) return;
        foreach (var hit in hits) {
            var projectable = hit.GetComponent<Projectable>();
            if (projectable == null) continue;

            Vector3 dir = Vector3.zero;
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
                        dir = projectable.velocity.normalized;
                        break;
                    }
                case RedirectType.SLOW:
                    {
                        dir -= projectable.velocity.normalized;
                        break;
                    }

            }
            Vector3 force = dir * this.force;
            projectable.AddForce(force);
        }
            
    }
}

