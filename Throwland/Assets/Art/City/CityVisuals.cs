using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class CityVisuals : MonoBehaviour
{
    public GameObject buildingVisualsPrefab;
    public Sprite[] buildingSprites;

    public float radius = 0.5f;
    public Vector2 grid;

    public float appearDelay = 0.05f;

    public Dictionary<Vector2, GameObject> slots = new Dictionary<Vector2, GameObject>();

    private int team;
    private Coroutine updateRadiusCoroutine;
    
    private void OnDrawGizmosSelected()
    {
        Vector2 pos = transform.position;
        Gizmos.DrawWireSphere(pos, radius);
        
    }

    private void Start()
    {
        UpdateRadius(this.radius);
    }

    public void SetTeamIndex(int teamIndex)
    {
        this.team = teamIndex;
        GetComponentInChildren<TeamColoredVisual>().teamIndex = teamIndex;
        if(this.updateRadiusCoroutine != null)
            StopCoroutine(this.updateRadiusCoroutine);
        updateRadiusCoroutine = StartCoroutine(this.UpdateRadiusCoroutine(this.radius));
    }

    public void UpdateRadius(float value)
    {
        if(this.updateRadiusCoroutine != null)
            StopCoroutine(this.updateRadiusCoroutine);
        
        updateRadiusCoroutine = StartCoroutine(this.UpdateRadiusCoroutine(value));
    }

    private IEnumerator UpdateRadiusCoroutine(float value)
    {
        Vector2 pos = transform.position;
        radius = value;
        for (int x = 0; x < grid.x; x++)
        {
            for (int y = 0; y < grid.y; y++)
            {
                float evalX = (float)x / (grid.x - 1);
                float xPos = Mathf.Lerp(pos.x - radius, pos.x + radius, evalX) + Random.Range(-this.radius / this.grid.x, this.radius / this.grid.x);
                float evalY = (float)y / (grid.y - 1);
                float yPos = Mathf.Lerp(pos.y - radius, pos.y + radius, evalY) + Random.Range(-this.radius / this.grid.y, this.radius / this.grid.y);

                Vector2 point = new Vector2(xPos, yPos);
                if (Vector2.Distance(point, pos) > radius + 0.1f /*|| this.slots.Any((e) => Vector2.Distance(e.Key, pos) < 0.3f)*/) continue;


                GameObject instance = Instantiate(buildingVisualsPrefab, point, Quaternion.identity, transform);
                SpriteRenderer rend = instance.GetComponentInChildren<SpriteRenderer>();
                rend.sprite = buildingSprites[Random.Range(0, buildingSprites.Length)];
                rend.GetComponent<TeamColoredVisual>().SetTeam(team);

                slots.TryAdd(point, instance);

                yield return new WaitForSeconds(appearDelay);
            }
        }
    }

    public void Spawn()
    {

    }
}
