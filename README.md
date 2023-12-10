# ZK-IA: In-browser ZK auth plugin for image integrity

> [!NOTE]
> ZK-IA aims to provide a browser plugin that supports in-browser ZKP generation for content creators and verification for content viewers. 

### :pencil: Details
The manipulation of digital images has become a significant challenge in maintaining information integrity. Traditional methods of ensuring image integrity often fall short due to their limitations in handling permissible image transformations or vulnerabilities to adversaries.

This research aim to proposes a browser plugin for publishing platforms such as [Medium](https://medium.com/) or [Mirror](https://mirror.xyz/). The plugin will enable content creators to generate ZKP for redacted images in their articles. On the other hand, content viewers can verify these proofs, ensuring that the redacted images they view are derived from the original photo and that the metadata matches the original. This process guarantees image integrity while preventing any inference of new information from the redacted images and proofs. Therefore, if the redacted images are verified, viewers can be confident that what they are seeing has not been sourced from tampered material, such as unauthorized edited photos or deepfake creations.


### :triangular_flag_on_post: Goals
Explore a reliable and feasible scheme for authenticating digital images on top of the state-of-the-art zk-SNARKs. Specifically, achieve image integrity where the redactions made by the owner are undeniable and traceable. Moreover, if any area has been legally edited, we want to attain area zero-knowledge, and it should be impossible to infer any information about the modified part from the proofs and post-processed images.


**Objectives:**
- Develop a PoC IA (image authentication) scheme where the performance is optimized among current protocols.
- Build a browser plugin on top of the IA scheme. ([working issues related to the plugin](https://github.com/moven0831/ZK-IA/issues/3))
- Ensure the plugin can correctly function on plublishing platforms with in feasible time.

| ![Flow of Redactable signature scheme for image](https://github.com/moven0831/ZK-IA/assets/60170228/0ebfa51d-b165-42e9-809b-eed66e0ee5b8) | 
|:--:| 
| *Expected user flow of the ZK-IA plugin* |


### :hammer: Working Status
Idea: In the first round of study, I've read through all the papers cited in references. It occurs to me that [image post-processing circuits](https://github.com/TrishaDatta/circom-circuits/tree/main) such as grayscaling, resizing, and cropping contain a few similar constraints that might be able to improve using recursive SNARK.

**Next step:**
1. Compile image post-processing circuits into Nova prover by [Nova Scotia](https://github.com/nalinbhardwaj/Nova-Scotia) (it supports [in-browser proving and verification](https://github.com/nalinbhardwaj/Nova-Scotia/tree/main/browser-test)).
2. Run [Nova](https://github.com/microsoft/Nova) and test the performances with the benchmarks in the papers. Construct a comparison table among existed protocols.
3. Study on the choices of hash function. I will continue the study on which combinations of them (e.g. Poseidon Hash + Lattice Hash) best fit the recursive SNARK.


### :dart: Milestones

| Status | Milestone | Objective | Tasks | Duration|
|-----------|-----------|-------|----------|--------|
| :white_check_mark:| Understanding and Preliminary Research | Gain a comprehensive understanding of current image authentication methods and their limitations. | Literature review and analysis of existing systems. Check [the intro slides](https://www.canva.com/design/DAF2dTFrzo0/He9DI7BjSfKtV0jYzMNrgA/view?utm_content=DAF2dTFrzo0&utm_campaign=designshare&utm_medium=link&utm_source=editor) | 2 weeks |
| :fast_forward: | Theoretical Scheme Development | Develop a theoretical scheme for IA (image authentication) using zk-SNARKs. | Formulating the theoretical aspects of using PCD for image authentication and defining permissible image transformations. | 3 weeks |
| :fast_forward: | Prototype Development | Create a working prototype of plugin that provides in-browser ZKP generation and verification on top of the IA scheme  | Implementing a prototype that supports a basic set of permissible transformations such as resizing. Which needs to work on at least one publishing platform. | 4 weeks |
| :fast_forward: | Benchmarking and Support more image transformations | Benchmark the plugin and the IA scheme. Extend the supported image transformations. Complete the UX details.  | Evaluating the prototype’s efficiency with benchmarks. Provide support for more image transformations such as grayscale and cropping.  | 3 weeks |
| :fast_forward: | Iteration and Documentation | Iterate the plugin based on user's testing feedback and prepare comprehensive documentation. | Refining the prototype, preparing documentation (for developer who want to build on top of the IA scheme mainly) and user manuals. | 2 weeks |


### References
- T. Datta and D. Boneh. 2022. ["Using ZK Proofs to Fight Disinformation"](https://medium.com/@boneh/using-zk-proofs-to-fight-disinformation-17e7d57fe52f). Medium Article.
- [[LHC23]](https://ieeexplore.ieee.org/abstract/document/10254440) Region-aware Photo Assurance System for Image Authentication
- [[LWW+22]](https://onlinelibrary.wiley.com/doi/full/10.1002/int.22830) A blockchain-based privacy-preserving authentication system for ensuring multimedia content integrity
- [[CHN+22]](https://ieeexplore.ieee.org/abstract/document/9740681) "VILS: A Verifiable Image Licensing System".
- [[LNS+22]](https://dl.acm.org/doi/abs/10.1145/3498361.3538943) "Vronicle: Verifiable Provenance for Videos from Mobile Devices".
- [[KLL+21]](https://dl.acm.org/doi/abs/10.1145/3433210.3453110) Efficient Verifiable Image Redacting based on zk-SNARKs
- [[ZLW19]](https://www.sciencedirect.com/science/article/pii/S0167404818313981) Blockchain-based photo forensics with permissible transformations
- [[KLK+19]](https://dl.acm.org/doi/abs/10.1145/3358195) AuthCropper: Authenticated Image Cropper for Privacy Preserving Surveillance Systems
- [[NRP19]](https://dl.acm.org/doi/abs/10.1145/3335203.3335729) Proving Multimedia Integrity using Sanitizable Signatures Recorded on Blockchain
- [[Korus17]](https://www.sciencedirect.com/science/article/pii/S1051200417301938) Digital image integrity – a survey of protection and verification techniques
- [[NT16]](https://ieeexplore.ieee.org/abstract/document/7546506) "PhotoProof: Cryptographic Image Authentication for Any Set of Permissible Transformations".
