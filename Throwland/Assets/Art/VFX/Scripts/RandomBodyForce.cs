using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomBodyForce : MonoBehaviour
{
    public float forceMultiplier = 1f;
    public float radialForceMin = 0.5f;
    public float radialForceMax = 1f;

    public Vector3 linearForceMin = Vector3.zero;
    public Vector3 linearForceMax = Vector3.zero;

    Rigidbody rb;

    public bool onAwake = false;

    private void Awake()
    {
        if (onAwake) Force();
    }

    public void Force()
    {
        if (rb == null) rb = GetComponent<Rigidbody>();

        float radForce = Random.Range(radialForceMax, radialForceMin);

        Vector3 radial = Random.insideUnitSphere * radForce;
        Vector3 linear = new Vector3(
            Random.Range(linearForceMin.x, linearForceMax.x),
            Random.Range(linearForceMin.y, linearForceMax.y),
            Random.Range(linearForceMin.z, linearForceMax.z));

        Vector3 final = radial + linear;

        rb.AddForce(final * forceMultiplier, ForceMode.Impulse);
    }
}
