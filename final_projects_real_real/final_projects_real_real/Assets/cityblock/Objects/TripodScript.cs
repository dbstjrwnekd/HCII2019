using UnityEngine;
using System.Collections;

public class TripodScript : MonoBehaviour
{

    private string objectName = "tripod";

    static Animator anim;
    public float speed = 0.0f;
    public float rotationSpeed = 0.0f;
    static int num_frame = 0;

    enum State
    {
        Idle,
        Hit
    }

    State currentState;

    // Use this for initialization
    void Start()
    {
        currentState = State.Idle;
        NextState();

        float rotation = Input.GetAxis("Horizontal") * rotationSpeed;
        rotation = rotation - 180;
        transform.Rotate(0, rotation, 0);

        anim = GetComponent<Animator> ();
    }

    // Update is called once per frame
    void Update()
    {
        num_frame += 1;

		if (num_frame < 1900) {
			speed = 0.0f;
		} else if (num_frame >= 1900 && num_frame < 2700) {
			speed = 0.045f;
		} else if (num_frame >= 2700 && num_frame < 2730) {
			speed = 0.0f;
		} else if (num_frame >= 2730 && num_frame < 2910) {
			rotationSpeed = 0.5f;

			float rotation = Input.GetAxis ("Horizontal") * rotationSpeed;
			rotation = rotation * Time.deltaTime + rotationSpeed;
			transform.Rotate (0, rotation, 0);

			speed = 0.045f;

		} else if (num_frame < 3350) {
			speed = 0.045f;
		} else {
			speed = 0.0f;
		}

        float translation = Input.GetAxis("Vertical");
        translation = translation * Time.deltaTime + speed;

        transform.Translate(0, 0, translation);

        if (translation != 0)
        {
            anim.SetBool("Iswalking", true);
        }
        else
        {
            anim.SetBool("Iswalking", false);
        }
    }

    public string Hit()
    {
        if (currentState == State.Hit)
        {
            return objectName;
        }
        else
        {
            currentState = State.Hit;
            return objectName;
        }

    }

    IEnumerator IdleState()
    {
        this.gameObject.transform.rotation = Quaternion.identity;

        while (currentState == State.Idle)
        {
            yield return null;
        }

        NextState();
    }


    IEnumerator HitState()
    {

        float hitTime = 0.5f;


        while (currentState == State.Hit)
        {
            yield return null;

            if (hitTime <= 0)
            {
                this.currentState = State.Idle;
            }
            hitTime -= Time.deltaTime;
        }

        NextState();
    }

    void NextState()
    {
        switch (currentState)
        {
            case State.Idle:
                StartCoroutine(IdleState());
                break;
            case State.Hit:
                StartCoroutine(HitState());
                break;
        }
    }
}