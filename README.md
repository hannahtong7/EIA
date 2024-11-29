# Ecological Impact Assessment of Two Hillsides in Lochranza, Isle of Arran, Scotland

## Project Overview

Human activities have significantly degraded ecosystems globally, leading to species decline and compromised ecosystem functions. This project conducts an **Ecological Impact Assessment (EIA)** of two hillsides in Lochranza, Isle of Arran, Scotland. By comparing biodiversity and habitat quality, the assessment aims to guide restoration efforts to improve ecological health.

### Key Findings

-   **South Hillside**:

    -   Higher biodiversity and presence of priority species, including the critically endangered *Sorbus arranensis*.

    -   The bog exhibits low biodiversity, requiring targeted restoration.

-   **North Hillside**:

    -   Greater ecological degradation, with more invasive species and poorer water quality.

    -   Supports unique nocturnal communities and higher vertebrate richness.

### Restoration Priorities

-   Restore the South Hillside while addressing key issues on the North Hillside such as invasive species management and water quality improvements.

------------------------------------------------------------------------

## Project Objectives

1.  **Compare Biodiversity Metrics**: Measure species richness, abundance, and distribution across plants, invertebrates, and vertebrates.

2.  **Assess Habitat Quality**: Focus on priority and invasive species.

3.  **Identify Restoration Areas**: Highlight ecological value and degradation levels.

4.  **Develop Tailored Recommendations**: Propose restoration strategies for each hillside.

------------------------------------------------------------------------

## Methodology

### Desk-Based Surveys

-   Identification of priority and invasive species using GIS, UK National Biodiversity Network data, and NatureScot resources.

### Field Surveys

-   **Phase I Habitat Survey**: Classification and mapping of vegetation and habitats.

-   **Invertebrates**:

    -   Sweep netting, light trapping, and kick-net sampling for aquatic species.

-   **Vertebrates**:

    -   Visual/audio surveys, camera traps, and passive acoustic monitoring for bats.

-   **Freshwater**:

    -   Water quality assessments using Water Quality Index (WQI) and Average Score Per Taxon (ASPT).

### Tools and Software

-   **GIS**: ArcGIS, QGIS for mapping study sites and habitat classifications.

-   **Data Analysis**: R with `vegan`, `rgbif`, and `ggplot2` packages for biodiversity indices and visualizations.

-   **Audio Analysis**: BatDetect2 for nocturnal vertebrate recordings.

------------------------------------------------------------------------

## Results

### Biodiversity Metrics

-   **South Hillside**:

    -   Higher alpha diversity for terrestrial invertebrates.

    -   Supports 8 Red List species, 10 Biodiversity Action Plan species, and 5 nationally scarce species.

    -   "Very clean" stream conditions (WQI: 9.1).

-   **North Hillside**:

    -   Higher nocturnal invertebrate and vertebrate richness.

    -   Hosts 9 invasive species and supports unique vertebrate communities.

    -   "Clean" stream conditions (WQI: 5.8).

### Diversity Indices

-   **Jaccard Index**: 0.4 (species similarity between sites).

-   **Sørensen Index**: 0.57 (community overlap).

------------------------------------------------------------------------

## Restoration Recommendations

### South Hillside

-   **Rhododendron ponticum Removal**: Use mechanical and herbicide methods to restore native woodland and protect *Sorbus arranensis*.

-   **Bog Restoration**: Rewetting to improve amphibian habitats and support pollinators.

-   **Wildflower Planting**: Enhance invertebrate diversity and ecosystem services.

-   **Bat Habitat Enhancement**: Install bat boxes and native hedgerows to increase roosting opportunities.

### North Hillside

-   **Invasive Species Management**: Prioritize removal of *Cotoneaster integrifolius* and *Epilobium ciliatum* to restore habitat integrity.

-   **Riparian Buffer Zones**: Improve stream water quality and habitat complexity by planting native vegetation.

-   **Grazing Management**: Reduce sheep grazing to promote vegetation recovery and enhance vertebrate habitats.

------------------------------------------------------------------------

## Limitations

-   **Sampling Periods**: Limited to a single season, introducing temporal bias.

-   **Accessibility**: Challenges in remote and steep areas reduced sampling intensity.

-   **Taxonomic Sensitivity**: Invertebrate identification to order level limited resolution.

------------------------------------------------------------------------

## Repository Contents

-   **`data/`**: Raw and processed biodiversity data.

-   **`scripts/`**: R scripts for data cleaning, analysis, and visualization.

-   **`figures/`**: Habitat maps, diversity indices, and comparative analyses.

-   **`docs/`**: Project report and supplementary materials.

------------------------------------------------------------------------

## Acknowledgments

This project was conducted by a multidisciplinary team of nine researchers specializing in ecology, taxonomy, and conservation. Special thanks to NatureScot and the UK National Biodiversity Network for data access and support.

------------------------------------------------------------------------

## How to Run the Analysis

1.  **Install Required Packages**:

    ```         
    install.packages(c("dplyr", "ggplot2", "vegan", "reshape2"))
    ```

2.  **Load Data**: Place datasets in the `data/` folder and ensure file paths are updated in scripts.

3.  **Run Scripts**: Execute analysis scripts in the `scripts/` folder to generate biodiversity metrics and visualizations.

4.  **Review Outputs**:

    -   Results will be saved in `figures/`.

    -   Processed data files will be in `data/`.

------------------------------------------------------------------------

## Contact

For questions or collaborations, contact Hannah Tong at s2743332\@ed.ac.uk.
