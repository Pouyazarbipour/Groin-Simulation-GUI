# Groin Simulation GUI

---

This MATLAB app simulates the deposition of sand on the updrift side and the erosion of sand on the downdrift side of a groin. The simulation uses a one-line contour model to calculate and visualize shoreline evolution over time.


## Key Features


- **Deposition & Erosion Modeling:** Simulates the deposition of sand on the updrift side and erosion on the downdrift side of a groin.
- **Dynamic Visualization:** Displays the shoreline evolution and real-time sediment transport (Q) as the simulation progresses.
- **Groin Influence:** Calculates the critical distance (`xm`) and when the groin starts bypassing sand (i.e., when the groin reaches its capacity).

---

## Components

1. **Input Fields:**
   - **Groin Length:** The length of the groin in meters.
   - **Wave Angle:** The breaking wave angle in degrees (converted to radians).
   - **Shoreline Diffusivity:** The shoreline diffusivity in m²/s.

2. **Control Buttons:**
   - **Calculate Button:** Starts the simulation with the given parameters.
   - **Stop Button:** Allows the user to stop the simulation.

3. **Real-Time Plot:**
   - The app generates a plot showing shoreline elevation over time. It includes the sediment transport rate (Q) and the critical distance (`xm`).

---

## Concepts

### 1. **Deposition & Erosion:**
- **Updrift Deposition:** Sand is trapped on the updrift side of the groin, causing the shoreline to extend.
- **Downdrift Erosion:** Sand is carried away from the downdrift side, leading to shoreline erosion.
- **Asymmetric Shoreline Evolution:** The deposition and erosion areas are symmetrical but opposite in effect.

### 2. **Sediment Transport Rate (Q):**
- The area accreted or eroded over time. This value is used to calculate the impounded sand volume.

### 3. **Impounded Sand Volume:**
- To calculate the impounded sand volume:
  \[
  \text{Impounded Volume} = Q \times (B + h*)
  \]
  - **B:** Berm height (vertical distance from the shoreline to the beach crest).
  - **h\*:** Depth of closure (depth at which wave action no longer moves sediment).

### 4. **Critical Distance (xm):**
- This distance represents the location where shoreline displacement is 1% of the groin length. It indicates the alongshore influence of the groin.

### 5. **Bypassing Time:**
- The simulation stops when the groin starts bypassing sand (when the trapping capacity is exceeded).

---

## Workflow

1. **Enter Parameters:** Input the groin length, wave angle, and diffusivity.
2. **Start Simulation:** Click the "Calculate" button to start the simulation.
3. **Visualize Results:** Watch the shoreline evolution on the plot in real time.
4. **Stop Simulation:** Click the "Stop" button to stop the simulation if needed.

## Example of the Simulation

The app will display a shoreline with the following features:
- The **magenta region** represents the evolving shoreline over time.
- The **vertical black line** represents the groin.
- The **horizontal black line** represents the original shoreline.
- The **width** of the magenta region represents the area affected by deposition and erosion over time.

The simulation stops once the groin reaches bypassing capacity.

## Suggestions for Future Enhancements

1. **Improved Visualization:**
   - Use different colors for deposition and erosion (e.g., green for deposition, red for erosion).
   - Add annotations for berm height (B), depth of closure (h*), and shoreline displacement.

2. **User-Controlled Parameters:**
   - Allow users to input **berm height (B)** and **depth of closure (h\*)** to dynamically compute the impounded sand volume.

3. **Extended Metrics:**
   - Add graphs for **Q(t)** and **xm(t)** to track changes over time.
   - Highlight **Bypassing Time** on the timeline.

4. **Export Functionality:**
   - Provide an option to **export simulation data** (e.g., shoreline evolution, impounded volume, bypassing time).
  
---

## License  
This project is licensed under the MIT License. See the `LICENSE` file for details.  

---

## Contact  
For questions or feedback, please reach out to pouyazarbipour@gmail.com.
