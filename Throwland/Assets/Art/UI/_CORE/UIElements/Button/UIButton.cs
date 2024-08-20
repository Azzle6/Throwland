using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class UIButton : MonoBehaviour, ISelectHandler, IDeselectHandler, IPointerEnterHandler, IPointerExitHandler
{
    public static float clickDelay = 0.07f;
    public Button Button { get; private set; }

    public virtual void Awake()
    {
        Button = GetComponent<Button>();
        Button.onClick.AddListener(ClickButton);
    }

    public virtual void OnDestroy()
    {
        Button.onClick.RemoveAllListeners();
    }

    public Action onClick;

    public void ClickButton()
    {
        //Button.Select();
        StartCoroutine(Clicking());
    }

    private IEnumerator Clicking()
    {
        yield return new WaitForSecondsRealtime(clickDelay);
        OnClicked();
        onClick?.Invoke();
    }

    public UnityEvent Event;
    public virtual void OnClicked()
    {
        Event?.Invoke();
    }

    public Action<UIButton> onSelect;
    public virtual void OnSelect(BaseEventData eventData)
    {
        onSelect?.Invoke(this);
    }
    public Action<UIButton> onDeselect;
    public void OnDeselect(BaseEventData eventData)
    {
        onDeselect?.Invoke(this);
    }

    public Action<UIButton> onStartHover;
    public void OnPointerEnter(PointerEventData eventData)
    {
        onStartHover?.Invoke(this);
    }

    public Action<UIButton> onStopHover;
    public void OnPointerExit(PointerEventData eventData)
    {
        onStopHover?.Invoke(this);
    }
}
