using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomBodyTorque : MonoBehaviour
{
    public bool onAwake = false;

    public float torqueMultiplier = 1f;
    public float minTorque = 1f;
    public float maxTorque = 1f;

    Rigidbody rb;

    private void Awake()
    {
        if (onAwake) Torque();
    }

    public void Torque()
    {
        if (rb == null) rb = GetComponent<Rigidbody>();

        float torque = Random.Range(minTorque, maxTorque);

        if (Random.Range(0f, 1f) > 0.5f) torque *= -1;

        rb.AddRelativeTorque(new Vector3(0, 0, torque * torqueMultiplier), ForceMode.Impulse);
    }
}
