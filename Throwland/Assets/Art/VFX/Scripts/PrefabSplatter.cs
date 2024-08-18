using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PrefabSplatter : MonoBehaviour
{
    public float radius = 5f;
    public LayerMask layerMask;
    public GameObject prefab;

    public bool enableSplatter = true;

    public List<GameObject> spawnedPrefabs = new List<GameObject>();

    public bool onAwake = false;

    private void OnDrawGizmosSelected()
    {
        Gizmos.DrawWireSphere(transform.position, radius);
    }

    public void Awake()
    {
        if (onAwake) Splatter();
    }

    public void Splatter()
    {

        if (!enableSplatter) return;

        Vector3 self = transform.position;
        Collider[] colliders = Physics.OverlapSphere(self, radius);
        if (colliders.Length == 0) return;

        foreach (var coll in colliders)
        {
            //Vector3 closest = coll.transform.position + coll.bounds.center;
            Vector3 closest = coll.ClosestPoint(self);

            Vector3 dir = (closest - self).normalized;
            Debug.DrawLine(self, self + dir * radius * 1.1f, Color.cyan, 5f);

            RaycastHit hit;
            bool cast = Physics.Raycast(self, dir, out hit, radius * 1.1f, layerMask, QueryTriggerInteraction.Ignore);
            if(cast)
            {
                Vector3 pos = hit.point;
                Quaternion rotation = Quaternion.LookRotation(hit.normal);
                GameObject instance = Instantiate(prefab, pos, rotation) ;
                spawnedPrefabs.Add(instance);
            }
        }
    }
}
