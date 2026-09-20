# Local run notes

Fork of [`climatechange-ai-tutorials/hands-on-outbreak-analytics`](https://github.com/climatechange-ai-tutorials/hands-on-outbreak-analytics)
for the [Climate Change AI Virtual Summer School 2026](https://www.climatechange.ai/events/summer_school2026),
sectoral module *AI for Public Health*.

- **Original tutorial:** Avinash Laddha (data.org), MIT licence,
  <https://doi.org/10.5281/zenodo.21940936>.
- **Completed by:** Mariano Huencho ([@choka30](https://github.com/choka30)), 2026-09-20.

`hands_on_outbreak_analytics.ipynb` is the upstream notebook, completed in place, with
all outputs saved. `git diff` against `upstream/main` shows every change.

## What I added

| Where | Content |
|---|---|
| After Exercise #1 | Lag correlation of cases against TEM, PP and H over 0 to 12 weeks, with an effective-sample-size correction, a figure, and the written answer. |
| After Exercise #2 | The climate-adjusted generation interval at 30 °C against the fixed web value, and the written answer. |
| Before the emissions cell | Section **My extra checks**: three tests of the tutorial's own claims, then **What I trust, and what I do not**, then the errors that I found. |

Written answers follow ASD-STE100 Simplified Technical English.

## My three checks, in one line each

1. **Is the headline robust?** Sweeping the fixed generation interval from 10 to 25 days
   gives 11 to 42 alert flips. The tutorial value of 15 days gives 13, near the bottom of
   that range. So the author chose a fair baseline, and the number 13 does not transfer
   to another city.
2. **Is the alert rule useful?** Both arms raise an alert in about 47% of all weeks. The
   comparison between the arms stays fair, but the rule itself is not yet an early
   warning.
3. **Does the LLM judge add value?** I built a card that satisfies all three numeric
   gates and inverts the biology. The judge returned 4 PASS and 3 REVISE over seven
   identical calls. Adding one explicit criterion about the direction of the temperature
   response made it return REVISE every time.

## Three errors that I found in the tutorial

1. **The LLM judge cannot run.** The code asks for `models/gemini-2.5-flash`. Google
   retired that name for new API keys, and the request returns `404 ... no longer
   available to new users`. The call sits inside a bare `except`, so the notebook prints
   a rule-based verdict and never says that the model refused it. Fixed by pinning
   `models/gemini-3.5-flash`, plus a retry for the free-tier rate limit.
2. **`PAPER_PDF` names the wrong paper.** The comment sends the reader to Ong et al.
   2022. But `rag_retrieve_gi_relationship()` searches the PDF for "intrinsic incubation"
   and "extrinsic incubation", and neither string appears in that paper. The incubation
   periods come from Chan and Johansson 2012. Fixed by downloading that paper instead, so
   the retrieval step now reports "source located and confirmed in PDF".
3. **`requirements.txt` is wrong in two places.** It omits `seaborn`, which cell 17
   imports. It lists `rpy2`, which no cell uses. See `requirements-local.txt`.

## Changes made only so the notebook runs outside Colab

| Cell | Change |
|---|---|
| pip install | Runs on Colab only, so it cannot write into the local virtual environment. |
| API key | `from google.colab import userdata` moved inside a `try`. A `.env` file is the local source of `GOOGLE_API_KEY`. |
| Paper download | The open-access PDF is fetched automatically. |

## How to run it

```bash
uv venv --python 3.13 .venv
uv pip install -r requirements-local.txt
cp .env.example .env        # then put your own key in it
./run_notebook.sh
```

No GPU is needed. The run takes about 2 minutes, and most of that is the pause that
respects the free-tier rate limit. CodeCarbon reports the energy in the last cell of
Part 3.
