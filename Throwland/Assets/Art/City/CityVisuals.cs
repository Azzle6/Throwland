using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static UnityEditor.PlayerSettings;

public class CityVisuals : MonoBehaviour
{
    public GameObject buildingVisualsPrefab;
    public Sprite[] buildingSprites;

    public float radius = 0.5f;
    public Vector2 grid;

    public float appearDelay = 0.05f;

    public Dictionary<Vector2, GameObject> slots = new Dictionary<Vector2, GameObject>();

    private void OnDrawGizmosSelected()
    {
        Vector2 pos = transform.position;
        Gizmos.DrawWireSphere(pos, radius);
        
    }

    private IEnumerator Start()
    {

        int team = GetComponentInChildren<TeamColoredVisual>().teamIndex;
        Vector2 pos = transform.position;
        for (int x = 0; x < grid.x; x++)
        {
            for (int y = 0; y < grid.y; y++)
            {
                float evalX = (float)x / (grid.x - 1);
                float xPos = Mathf.Lerp(pos.x - radius, pos.x + radius, evalX);
                float evalY = (float)y / (grid.y - 1);
                float yPos = Mathf.Lerp(pos.y - radius, pos.y + radius, evalY);

                Vector2 point = new Vector2(xPos, yPos);
                if (Vector2.Distance(point, pos) > radius + 0.1f) continue;


                GameObject instance = Instantiate(buildingVisualsPrefab, point, Quaternion.identity, transform);
                SpriteRenderer rend = instance.GetComponentInChildren<SpriteRenderer>();
                rend.sprite = buildingSprites[Random.Range(0, buildingSprites.Length)];
                rend.GetComponent<TeamColoredVisual>().SetTeam(team);

                slots.Add(point, instance);

                yield return new WaitForSeconds(appearDelay);
            }
        }
    }

    public void Spawn()
    {

    }
}
