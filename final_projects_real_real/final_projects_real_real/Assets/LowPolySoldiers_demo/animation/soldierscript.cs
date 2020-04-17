using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class soldierscript : MonoBehaviour {
    private string objectName = "shooter";

    static Animator anim;
    static AudioSource sound;
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

        anim = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        num_frame += 1;
        if(num_frame < 1600)
        {
            sound = GetComponent<AudioSource>();
            sound.volume = 0;
            speed = 0.0f;
        }
        else if (num_frame < 2150)
        {
            
            speed = 0.05f;
            sound.volume = 0;
        }
        else if (num_frame >= 2150 && num_frame < 2210)
        {
			rotationSpeed = 3.0f;

			float rotation = Input.GetAxis("Horizontal") * rotationSpeed;
			rotation = rotation * Time.deltaTime + rotationSpeed;
			transform.Rotate(0, rotation, 0);

			speed = 0.05f;

        }
        else if (num_frame >= 2210 && num_frame < 2480)
        {
            
            speed = 0.0f;
            sound.volume = 0;
        }
        else if (num_frame >= 2480 && num_frame < 2510)
        {

            rotationSpeed = -3.0f;
            
            float rotation = Input.GetAxis("Horizontal") * rotationSpeed;
            rotation = rotation * Time.deltaTime + rotationSpeed;
            transform.Rotate(0, rotation, 0);

            speed = 0.03f;
            sound.volume = 0;
        }
        else if (num_frame < 5300)
        {
            
            speed = 0.09f;
            if(num_frame < 2700)
            {
                sound.volume = num_frame / 2700.0f;
            }
            else
            {
                sound.volume = 2700.0f / num_frame;
            }
        }
        else
        {

            
            speed = 0.0f;
            sound.volume = 0;
        }

        float translation = Input.GetAxis("Vertical");
        translation = translation * Time.deltaTime + speed;

        transform.Translate(0, 0, translation);

        if (translation == 0)
        {
            anim.SetBool("Isshooting", true);
        }
        else
        {
            anim.SetBool("Isshooting", false);
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

