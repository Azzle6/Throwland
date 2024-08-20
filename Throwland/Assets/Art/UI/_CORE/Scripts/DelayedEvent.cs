using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class DelayedEvent : MonoBehaviour
{
    public UnityEvent Event;
    public float delay = 0.05f;
    public Action action;

    public void Play(int index, Action action = null)
    {
        this.action = action;
        StartCoroutine(Delaying(index));
    }

    private IEnumerator Delaying(int index)
    {
        yield return new WaitForSeconds(delay * index);

        this.action?.Invoke();
        Event?.Invoke();
    }
}
