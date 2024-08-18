using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PerlinMovement : MonoBehaviour
{
    Vector2 eval;
    public Vector2 frequency = Vector3.one;
    public Vector2 amplitude = Vector3.one;
    public bool randomSeed;

    public bool local = false;

    private void Awake()
    {
        eval += new Vector2(Random.Range(0f, 10f), Random.Range(0f, 10f));
    }

    private void Update()
    {
        Vector2 add = frequency * Time.deltaTime;
        eval += add;

        float x = (Mathf.PerlinNoise(eval.x, -eval.x / 2f) - 0.5f) * amplitude.x;
        float y = (Mathf.PerlinNoise(eval.y, -eval.y / 2f) - 0.5f) * amplitude.y;

        if (local) transform.localPosition = new Vector2(x, y);
        else transform.position += new Vector3(x, 0, y) * Time.deltaTime;
    }
}
