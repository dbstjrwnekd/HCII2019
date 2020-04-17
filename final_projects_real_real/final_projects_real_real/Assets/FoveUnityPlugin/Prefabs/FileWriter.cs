using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using System.Text;
using System;
using UnityEngine.SceneManagement;
using Fove;


public class FileWriter : MonoBehaviour
{
    public Camera MainCamera;

    /*
    * Instantiate StreamWriter and create file to write to
    This needs to be global as i am using this in a number of methods and
    i have no idea if it can be passed to Unity built in method
    */
    public static StreamWriter SW;
    //Assigned to the camera transform object
    public Transform camHead;
    //Array of Vector3 to hold LeftEye pos, RightEye Pos, Head Pos when button pressed
    public static Vector3[] startPos, endPos;
    //boolean used to see which state the game is in
    //end state means:
    //start state means:
    private static bool startPress, endPress;

    //for 전역변수 string
    string sum_data = "";

    // Use this for initialization
    void Start()
    {

        //File path in string. Change as needed
        String filePath = "./fove.csv";
        //Set StreamWriter path and catch exceptions if it cant be set
        SW = new StreamWriter(filePath);
        //Set the endPress to True and startPress to false
        endPress = true;
        startPress = false;
        /*
        String sceneNme = SceneManager.GetActiveScene().name;
        WriteFrameData(sceneNme);
        */
        //Feature name을 위한 string배열과 기본 string 형성
        string[] feature_names = new string[13];
        string ld = "current_ray_data_ld";
        string lo = "current_ray_data_lo";
        string rd = "current_ray_data_rd";
        string ro = "current_ray_data_rd";
        //배열에 이름들 할당
        for (int i=0; i<3; i++)
        {
            if(i%2==0 && i!=0)
            {
                feature_names[i] = ld + ".z";
                feature_names[i + 3] = lo + ".z";
                feature_names[i + 6] = rd + ".z";
                feature_names[i + 9] = ro + ".z";
            }
            else if(i%1==0 && i!=0)
            {
                feature_names[i] = ld + ".y";
                feature_names[i + 3] = lo + ".y";
                feature_names[i + 6] = rd + ".y";
                feature_names[i + 9] = ro + ".y";
            }
            else
            {
                feature_names[i] = ld + ".x";
                feature_names[i + 3] = lo + ".x";
                feature_names[i + 6] = rd + ".x";
                feature_names[i + 9] = ro + ".x";
            }
        }
        feature_names[12] = "object_name";
        string feature_name = "";
        for(int i = 0; i < 13; i++)
        {
            feature_name += feature_names[i];
            if (i != 12)
            {
                feature_name += ",";
            }
        }
        WriteFrameData(feature_name);
        

    }

    // Update is called once per frame
    void Update()
    {
        /*
        Vector3[] current_fove_pos = new Vector3[] {FoveInterface.GetLeftEyeVector(), FoveInterface.GetRightEyeVector(), FoveInterface.GetHMDPosition(), FoveInterface.GetHMDRotation().eulerAngles};
        string current_fove_data = "";
        for (int i = 0; i < current_fove_pos.Length; i++)
        {
            current_fove_data = current_fove_data + current_fove_pos[i].x + "," + current_fove_pos[i].y + "," + current_fove_pos[i].z + "|";
        }
        WriteFrameData(current_fove_data);
        */

        Ray left_ray = FoveInterface.GetEyeRays().left;
        Ray right_ray = FoveInterface.GetEyeRays().right;

        string current_ray_data_ld = /*"left ray direction data : " + */left_ray.direction.x.ToString() + ", " + left_ray.direction.y.ToString() + ", " + left_ray.direction.z.ToString();
        string current_ray_data_lo = /*"left ray origin data : " + */left_ray.origin.x.ToString() + ", " + left_ray.origin.y.ToString() + ", " + left_ray.origin.z.ToString();
        string current_ray_data_rd = /*"right ray direction data : " + */right_ray.direction.x.ToString() + ", " + right_ray.direction.y.ToString() + ", " + right_ray.direction.z.ToString();
        string current_ray_data_ro = /*"right ray origin data : " + */right_ray.origin.x.ToString() + ", " + right_ray.origin.y.ToString() + ", " + right_ray.origin.z.ToString();

        sum_data = current_ray_data_ld + "," + current_ray_data_lo + "," + current_ray_data_rd + "," + current_ray_data_ro;
        //WriteFrameData(sum_data);
        /*
        WriteFrameData(current_ray_data_ld);
        WriteFrameData(current_ray_data_lo);
        WriteFrameData(current_ray_data_rd);
        WriteFrameData(current_ray_data_ro);
        */

        rayCasting(right_ray);
        WriteFrameData(sum_data);
        /*

        if (Input.GetMouseButtonUp(0))
        {
            // Ray 객체 생성
            Ray ray = MainCamera.ScreenPointToRay(Input.mousePosition);
            

            // rayCasting 실행
            rayCasting(ray);

            WriteFrameData(ray.ToString());
        }

        //DebugPr(FoveInterface.GetLeftEyeVector().x + ", " + FoveInterface.GetLeftEyeVector().y + ", " + FoveInterface.GetLeftEyeVector().z);
        if (Input.GetKeyDown(KeyCode.Backslash))
        {
            if (startPress == false && endPress == true)
            {
                startPos = new Vector3[] {FoveInterface.GetLeftEyeVector(), FoveInterface.GetRightEyeVector(),
FoveInterface.GetHMDPosition(), FoveInterface.GetHMDRotation().eulerAngles};
                DebugPr("backslash Key Pressed " + "startPos Length is " + startPos.Length);
                startPress = true;
                endPress = false;
            }

        }

        if (Input.GetKeyDown(KeyCode.Slash))
        {
            if (startPress == true && endPress == false)
            {
                endPos = new Vector3[] {FoveInterface.GetLeftEyeVector(), FoveInterface.GetRightEyeVector(),
FoveInterface.GetHMDPosition(), FoveInterface.GetHMDRotation().eulerAngles};
                DebugPr("slash Key Pressed " + "endPos Length is " + endPos.Length);
                startPress = false;
                endPress = true;
            }

        }

        //this is a temporary condition to quit the app and write the data to the file
        //using this untill i figure out what i want to do
        if (Input.GetKeyDown(KeyCode.Space))
        {
            DebugPr("Space Key Pressed");
            if (startPress == false && endPress == true)
            {
                String foveData = "";
                for (int i = 0; i < startPos.Length; i++)
                {
                    foveData = foveData + startPos[i].x + "," + startPos[i].y + "," + startPos[i].z + "|";
                }
                for (int j = 0; j < endPos.Length; j++)
                {
                    foveData = foveData + endPos[j].x + "," + endPos[j].y + "," + endPos[j].z + "|";
                }
                WriteFrameData(foveData);
            }
        }
        */

    }
    

    void rayCasting(Ray ray)
    {
        RaycastHit hitObj;
        if (Physics.Raycast(ray, out hitObj, Mathf.Infinity))
        {
            if (hitObj.transform.tag.Equals("tripod"))
            {
                TripodScript tripodScript = hitObj.transform.GetComponent<TripodScript>();
                if (null != tripodScript)
                {
                    sum_data += ("," + tripodScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("planks_1"))
            {
                PlankScript plankScript = hitObj.transform.GetComponent<PlankScript>();
                if (null != plankScript)
                {
                    sum_data += ("," + plankScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("car2"))
            {
                Car2Script car2Script = hitObj.transform.GetComponent<Car2Script>();
                if (null != car2Script)
                {
                    sum_data += ("," + car2Script.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("car1"))
            {
                Car1Script capsuleScript = hitObj.transform.GetComponent<Car1Script>();
                if (null != capsuleScript)
                {
                    sum_data += ("," + capsuleScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("Terrain"))
            {
                TerrainScript treeScript = hitObj.transform.GetComponent<TerrainScript>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("detailstone1"))
            {
                Detailstone1Script treeScript = hitObj.transform.GetComponent<Detailstone1Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("detailstone2"))
            {
                Detailstone2Script treeScript = hitObj.transform.GetComponent<Detailstone2Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rocks1_1"))
            {
                Rocks1_1Script treeScript = hitObj.transform.GetComponent<Rocks1_1Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rocks2"))
            {
                Rocks2Script treeScript = hitObj.transform.GetComponent<Rocks2Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rocks1_2"))
            {
                Rocks1_2Script treeScript = hitObj.transform.GetComponent<Rocks1_2Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rock1"))
            {
                Rock1Script treeScript = hitObj.transform.GetComponent<Rock1Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rock1_1"))
            {
                Rock1_1Script treeScript = hitObj.transform.GetComponent<Rock1_1Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rock1_2"))
            {
                Rock1_2Script treeScript = hitObj.transform.GetComponent<Rock1_2Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rock1_3"))
            {
                Rock1_3Script treeScript = hitObj.transform.GetComponent<Rock1_3Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rock1_4"))
            {
                Rock1_4Script treeScript = hitObj.transform.GetComponent<Rock1_4Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rock2"))
            {
                Rock2Script treeScript = hitObj.transform.GetComponent<Rock2Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rock2_1"))
            {
                Rock2_1Script treeScript = hitObj.transform.GetComponent<Rock2_1Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rock3"))
            {
                Rock3Script treeScript = hitObj.transform.GetComponent<Rock3Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rock3_1"))
            {
                Rock3_1Script treeScript = hitObj.transform.GetComponent<Rock3_1Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rockarc1"))
            {
                Rockarc1Script treeScript = hitObj.transform.GetComponent<Rockarc1Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rock2_2"))
            {
                Rock2_2Script treeScript = hitObj.transform.GetComponent<Rock2_2Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rock1_5"))
            {
                Rock1_5Script treeScript = hitObj.transform.GetComponent<Rock1_5Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rock4"))
            {
                Rock4Script treeScript = hitObj.transform.GetComponent<Rock4Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rock1_6"))
            {
                Rock1_6Script treeScript = hitObj.transform.GetComponent<Rock1_6Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rocks 1"))
            {
                Rocks_1Script treeScript = hitObj.transform.GetComponent<Rocks_1Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rock1_7"))
            {
                Rock1_7Script treeScript = hitObj.transform.GetComponent<Rock1_7Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rock1_8"))
            {
                Rock1_8Script treeScript = hitObj.transform.GetComponent<Rock1_8Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rock2_3"))
            {
                Rock2_3Script treeScript = hitObj.transform.GetComponent<Rock2_3Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rock5"))
            {
                Rock5Script treeScript = hitObj.transform.GetComponent<Rock5Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("rock6"))
            {
                Rock6Script treeScript = hitObj.transform.GetComponent<Rock6Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b1_bench_1_2"))
            {
                Bench_1_2Script treeScript = hitObj.transform.GetComponent<Bench_1_2Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b1_bench_2"))
            {
                Bench_2Script treeScript = hitObj.transform.GetComponent<Bench_2Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b1_bench_2_2"))
            {
                Bench_2_2Script treeScript = hitObj.transform.GetComponent<Bench_2_2Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b1_building1_1"))
            {
                Building1_1Script treeScript = hitObj.transform.GetComponent<Building1_1Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b1_building1_2"))
            {
                Building1_2Script treeScript = hitObj.transform.GetComponent<Building1_2Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b1_building2_2_2"))
            {
                Building2_2_2Script treeScript = hitObj.transform.GetComponent<Building2_2_2Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b1_building2_2_3"))
            {
                Building2_2_3Script treeScript = hitObj.transform.GetComponent<Building2_2_3Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b1_building4_2"))
            {
                Building4_2Script treeScript = hitObj.transform.GetComponent<Building4_2Script>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b1_building5_1"))
            {
                Building5_1 treeScript = hitObj.transform.GetComponent<Building5_1>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b1_pavement_2"))
            {
                Pavement_2 treeScript = hitObj.transform.GetComponent<Pavement_2>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("pavementbricks"))
            {
                Pavementbricks treeScript = hitObj.transform.GetComponent<Pavementbricks>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("pavementbricks_1"))
            {
                Pavementbricks_1 treeScript = hitObj.transform.GetComponent<Pavementbricks_1>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("planks"))
            {
                Planks treeScript = hitObj.transform.GetComponent<Planks>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("planks_1"))
            {
                Planks_1 treeScript = hitObj.transform.GetComponent<Planks_1>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("planks_2"))
            {
                Planks_2 treeScript = hitObj.transform.GetComponent<Planks_2>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("sideblock1"))
            {
                Sideblock1 treeScript = hitObj.transform.GetComponent<Sideblock1>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("sideblock1_1_2"))
            {
                Sideblock1_1_2 treeScript = hitObj.transform.GetComponent<Sideblock1_1_2>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("sideblock1_2"))
            {
                Sideblock1_2 treeScript = hitObj.transform.GetComponent<Sideblock1_2>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("wire_1"))
            {
                Wire_1 treeScript = hitObj.transform.GetComponent<Wire_1>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("wire_4"))
            {
                Wire_4 treeScript = hitObj.transform.GetComponent<Wire_4>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("wire_5"))
            {
                Wire_5 treeScript = hitObj.transform.GetComponent<Wire_5>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("wire_6"))
            {
                Wire_6 treeScript = hitObj.transform.GetComponent<Wire_6>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("wire_7"))
            {
                Wire_7 treeScript = hitObj.transform.GetComponent<Wire_7>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("wire_8"))
            {
                Wire_8 treeScript = hitObj.transform.GetComponent<Wire_8>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("wire_9"))
            {
                Wire_9 treeScript = hitObj.transform.GetComponent<Wire_9>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("bench"))
            {
                Bench treeScript = hitObj.transform.GetComponent<Bench>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("bench_1"))
            {
                Bench_1 treeScript = hitObj.transform.GetComponent<Bench_1>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b2building2_2"))
            {
                Building2_2 treeScript = hitObj.transform.GetComponent<Building2_2>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b2building4"))
            {
                Building4 treeScript = hitObj.transform.GetComponent<Building4>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b2building5"))
            {
                Building5 treeScript = hitObj.transform.GetComponent<Building5>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b2pavement"))
            {
                Pavement treeScript = hitObj.transform.GetComponent<Pavement>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b2sideblock1_1"))
            {
                Sideblock1_1 treeScript = hitObj.transform.GetComponent<Sideblock1_1>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("wire"))
            {
                Wire treeScript = hitObj.transform.GetComponent<Wire>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("wire_2"))
            {
                Wire_2 treeScript = hitObj.transform.GetComponent<Wire_2>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("wire_3"))
            {
                Wire_3 treeScript = hitObj.transform.GetComponent<Wire_3>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("block3"))
            {
                Block3 treeScript = hitObj.transform.GetComponent<Block3>();
                if (null != treeScript)
                {
                    sum_data += (","+treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("floor"))
            {
                Floor treeScript = hitObj.transform.GetComponent<Floor>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("pavementbricks_1_2"))
            {
                Pavementbricks_1_2 treeScript = hitObj.transform.GetComponent<Pavementbricks_1_2>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("streetlight"))
            {
                Streetlight treeScript = hitObj.transform.GetComponent<Streetlight>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("streetlight_1"))
            {
                Streetlight_1 treeScript = hitObj.transform.GetComponent<Streetlight_1>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("streetlight_2"))
            {
                Streetlight_2 treeScript = hitObj.transform.GetComponent<Streetlight_2>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b4bench"))
            {
                B4Bench treeScript = hitObj.transform.GetComponent<B4Bench>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b4bench_1"))
            {
                B4Bench_1 treeScript = hitObj.transform.GetComponent<B4Bench_1>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b4building2_2"))
            {
                B4Building2_2 treeScript = hitObj.transform.GetComponent<B4Building2_2>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b4building4"))
            {
                B4Building4 treeScript = hitObj.transform.GetComponent<B4Building4>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b4building5"))
            {
                B4Building5 treeScript = hitObj.transform.GetComponent<B4Building5>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b4pavement"))
            {
                B4Pavement treeScript = hitObj.transform.GetComponent<B4Pavement>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b4sideblock1_1"))
            {
                b4sideblock1_1 treeScript = hitObj.transform.GetComponent<b4sideblock1_1>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b4wire"))
            {
                b4wire treeScript = hitObj.transform.GetComponent<b4wire>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b4wire_2"))
            {
                b4wire_2 treeScript = hitObj.transform.GetComponent<b4wire_2>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("b4wire_3"))
            {
                b4wire_3 treeScript = hitObj.transform.GetComponent<b4wire_3>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("crate"))
            {
                Crate treeScript = hitObj.transform.GetComponent<Crate>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("crate_1"))
            {
                Crate_1 treeScript = hitObj.transform.GetComponent<Crate_1>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("trash"))
            {
                Trach treeScript = hitObj.transform.GetComponent<Trach>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("streetlight(out)"))
            {
                streetlightout treeScript = hitObj.transform.GetComponent<streetlightout>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("streetlight1(out)"))
            {
                streetlight1out treeScript = hitObj.transform.GetComponent<streetlight1out>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("streetlight2(out)"))
            {
                streetlightout2 treeScript = hitObj.transform.GetComponent<streetlightout2>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("streetlight3(out)"))
            {
                streetlightout3 treeScript = hitObj.transform.GetComponent<streetlightout3>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("streetlight_4(out)"))
            {
                streetlightout_4 treeScript = hitObj.transform.GetComponent<streetlightout_4>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("streetlight_3(out)"))
            {
                streetlightout_3 treeScript = hitObj.transform.GetComponent<streetlightout_3>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("streetlight_2(out)"))
            {
                streetlightout_2 treeScript = hitObj.transform.GetComponent<streetlightout_2>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("streetlight_1(out)"))
            {
                streetlightout_1 treeScript = hitObj.transform.GetComponent<streetlightout_1>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("streetlight_(out)"))
            {
                streetlightout_ treeScript = hitObj.transform.GetComponent<streetlightout_>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("trashcan2"))
            {
                Trashcan2 treeScript = hitObj.transform.GetComponent<Trashcan2>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("trashcan1"))
            {
                Trashcan_1 treeScript = hitObj.transform.GetComponent<Trashcan_1>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
            else if (hitObj.transform.tag.Equals("trashcan"))
            {
                Trashcan treeScript = hitObj.transform.GetComponent<Trashcan>();
                if (null != treeScript)
                {
                    sum_data += ("," + treeScript.Hit());
                }
            }
			else if (hitObj.transform.tag.Equals("plane"))
			{
				Trashcan treeScript = hitObj.transform.GetComponent<Trashcan>();
				if (null != treeScript)
				{
					sum_data += ("," + treeScript.Hit());
				}
			}
			else if (hitObj.transform.tag.Equals("shooter"))
			{
				Trashcan treeScript = hitObj.transform.GetComponent<Trashcan>();
				if (null != treeScript)
				{
					sum_data += ("," + treeScript.Hit());
				}
			}
			else if (hitObj.transform.tag.Equals("runner"))
			{
				Trashcan treeScript = hitObj.transform.GetComponent<Trashcan>();
				if (null != treeScript)
				{
					sum_data += ("," + treeScript.Hit());
				}
			}
			else if (hitObj.transform.tag.Equals("back"))
			{
				Trashcan treeScript = hitObj.transform.GetComponent<Trashcan>();
				if (null != treeScript)
				{
					sum_data += ("," + treeScript.Hit());
				}
			}
        }
    }

    // Update is called once per frame
    void LastUpdate()
    {
        //At the end of each update set the camera position back to 0,0,0
        //Only way i have found to lock the camera position at a certain place
        camHead.position = new Vector3(0, 0, 0);
    }

    void OnApplicationQuit()
    {
        WriteFrameData("Closing :" + Time.frameCount + " -- " + Time.realtimeSinceStartup);
        //Close the StreamWriter object on apoplication quit
        SW.Close();
    }

    //This function is used to write all the data to the text file
    static void WriteFrameData(string msg)
    {
        SW.WriteLine(msg);
    }

    //Function to make debugging less of a mission
    public static void DebugPr(string msg)
    {
        Debug.Log(msg);
    }

}