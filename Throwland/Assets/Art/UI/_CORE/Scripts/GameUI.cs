using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class GameUI : Singleton<GameUI>
{
    public static bool IsHoveringUI => EventSystem.current.IsPointerOverGameObject();

    //public static bool IsHoveringUI
    //{
    //    get
    //    {
    //        EventSystem eventSystem = EventSystem.current;

    //        if (eventSystem == null) return false;

    //        PointerEventData pointerEventData = new PointerEventData(eventSystem);
    //        pointerEventData.position = Mouse.current.position.ReadValue();
    //        List<RaycastResult> raycastResultsList = new List<RaycastResult>();
    //        eventSystem.RaycastAll(pointerEventData, raycastResultsList);
    //        for (int i = 0; i < raycastResultsList.Count; i++)
    //        {
    //            if (raycastResultsList[i].gameObject.GetType() == typeof(GameObject))
    //            {
    //                return true;
    //            }
    //        }
    //        return false;
    //    }
    //}

    public void ToggleUI(bool enable)
    {
        Canvas[] canvas = FindObjectsByType<Canvas>(FindObjectsSortMode.None);

        foreach (var c in canvas)
        {
            c.enabled = enable;
        }
    }
}
