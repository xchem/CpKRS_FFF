# FFF_Template

To use this repository:

1. Use this template to create a new repository
1. Clone the newly repository on IRIS
1. Follow the steps indicated below

## 1. Dependencies

Skip this section if you have run a FFF campaign with this template before

### Pre-requisites

- [ ] SSH access to STFC/IRIS
- [ ] Working directory in `cepheus-slurm:/opt/xchem-fragalysis-2/`
- [ ] Conda setup w/ `python >= 3.10`
- [ ] Start a Jupyter notebook server in a SLURM job
- [ ] Set up [BulkDock](https://github.com/mwinokan/BulkDock)
- [ ] Install `dev` branch of [HIPPO](https://github.com/mwinokan/HIPPO)
- [ ] Install [Fragmenstein](https://github.com/matteoferla/Fragmenstein)
- [ ] Install [FragmentKnitwork](https://github.com/xchem/FragmentKnitwork) (optional, on a VM with a fragment network graph database)
- [ ] Install [syndirella](https://github.com/kate-fie/syndirella)
- [ ] Install [RichQueue](https://github.com/mwinokan/RichQueue)
- [ ] Install [PoseButcher](https://github.com/mwinokan/PoseButcher) (optional, useful if you have many subsites)

### Checklist

- [ ] you can ssh to IRIS (cepheus-slurm.diamond.ac.uk)
- [ ] you can source a file to set up conda (e.g. create a bashrc_slurm.sh)
- [ ] you can connect to a Jupyter notebook on IRIS
- [ ] you can run `python -m bulkdock status` from the BulkDock directory
- [ ] you can `import hippo` from a notebook
- [ ] you can run `fragmenstein --help`
- [ ] you can ssh to the sw-graph VM (optional, only for Knitwork)
- [ ] you can run `syndirella --help`

## 2. Setup

- [x] Define merging opportunities by creating tags of LHS hits in Fragalysis
- [x] Download target from Fragalysis and place the .zip archive in the repo
- [x] Setup target in BulkDock 

```
cp -v CpKRS.zip $BULK/TARGETS
cd $BULK
python -m bulkdock extract CpKRS
python -m bulkdock setup CpKRS
```

- [x] Copy the `aligned_files` directory from `$BULK/TARGETS/CpKRS/aligned_files` into this repository

```
cd - 
cp -rv $BULK/TARGETS/CpKRS/aligned_files .
```

## 3. Compound Design

- [x] run the notebook `hippo/1_merge_prep.ipynb`

### Fragmenstein

For each merging hypothesis

- [x] go to the fragmenstein subdirectory `cd fragmenstein`
- [x] queue fragmenstein job 

```sb.sh --job-name "CpKRS_iter1_fragmenstein" $HOME2/slurm/run_bash_with_conda.sh run_fragmenstein.sh iter1```

This will create outputs in the chosen iter1 subdirectory:

- **`iter1_fstein_bulkdock_input.csv`: use this for BulkDock placement**
- `output`: fragmenstein merge poses in subdirectories
- `output.sdf`: fragmenstein merge ligand conformers
- `output.csv`: fragmenstein merge metadata

- [x] placement with bulkdock

```
cp -v iter1/iter1_fstein_bulkdock_input.csv $BULK/INPUTS/TARGET_iter1_fstein.csv
cd $BULK
python -m bulkdock place CpKRS INPUTS/TARGET_iter1_fstein.csv
```

- [x] monitor placements

```
python -m bulkdock status
```

- [x] export Fragalysis SDF

```
sb.sh --job-name "bulkdock_out" $HOME2/slurm/run_python.sh -m bulkdock to-fragalysis TARGET OUTPUTS/SDF_FILE METHOD_NAME
```

### Fragment Knitwork

Running Fragment Knitting currently requires access to a specific VM known as `graph-sw-2`. If you don't have access, skip this section

- [x] `git add`, `commit` and `push` the contents of `aligned_files` and `knitwork` to the repository
- [x] `git clone` the repository on `graph-sw-2`
- [x] navigate to the `knitwork` subdirectory

Then, for each merging hypothesis:

- [x] Run the "fragment" step of FragmentKnitwork: `./run_fragment.sh iter1`
- [x] Run the pure "knitting" step of FragmentKnitwork: `./run_knitwork_pure.sh iter1`
- [x] Run the impure "knitting" step of FragmentKnitwork: `./run_knitwork_impure.sh iter1`
- [x] Create the BulkDock inputs: `python to_bulkdock.py iter1`
- [x] `git add`, `commit` and `push` the CSVs created by the previous step
- [x] back on `cepheus-slurm` pull the latest changes
- [x] Run BulkDock placement as for Fragmenstein above (running)

```
cp -v iter1/iter1_knitwork_pure.csv $BULK/INPUTS/TARGET_iter1_knitwork_pure.csv
cp -v iter1/iter1_knitwork_impure.csv $BULK/INPUTS/TARGET_iter1_knitwork_impure.csv
cd $BULK
python -m bulkdock place CpKRS INPUTS/TARGET_iter1_knitwork_pure.csv
python -m bulkdock place CpKRS INPUTS/TARGET_iter1_knitwork_impure.csv
```

- [x] Export Fragalysis SDF as for Fragmenstein

## 4. Scaffold selection

### Syndirella retrosynthesis
### Review chemistry
### HIPPO filtering
### Fragalysis curation

## 5. Syndirella elaboration

## 6. HIPPO

### Load elaborations
### Quote reactants
### Solve routes
### Calculate interactions
### Generate random recipes
### Score random recipes
### Optimise best recipes
### Create proposal web page

## 7. Review & order

### Review chemistry
### Order reactants
