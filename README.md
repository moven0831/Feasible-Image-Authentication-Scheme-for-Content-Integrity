# ZK-IA: Feasible image authentication scheme for content integrity using ZK

### :pencil: Abstract
The manipulation of digital images has become a significant challenge in maintaining information integrity in the digital age. Traditional methods of ensuring image integrity often fall short due to their limitations in handling permissible image transformations or vulnerabilities to adversaries. This research aim to proposes a novel approach using Zero-Knowledge Proof (ZKP) technology to provide a robust, secure, and efficient method of proving image integrity. Our goal is to demonstrate the feasibility of this approach by developing a web application or browser plugins that support functionalities like ZKP proof generation and verification for images.


### :triangular_flag_on_post: Goals
Explore a reliable and feasible method for authenticating digital images, even if they are generated by AI, using ZKP. Specifically, achieve image integrity where the redactions made by the owner are undeniable and traceable. Moreover, if any area has been legally edited, we want to attain area zero-knowledge, and it should be impossible to infer any information about the modified part from the proofs and post-processed image.

**Objectives:**
- Develop a PoC image authentication protocol where the performance is optimized among current protocols.
- Build a web application or browser plugin to demonstrate the simple use case of this protocol.
- Ensure the system supports basic permissible image transformations such as grayscale, cropping, and resizing without compromising integrity.


### :hammer: Working Status
Idea: In the first round of study, I've read through all the papers cited in references. It occurs to me that [image post-processing circuits](https://github.com/TrishaDatta/circom-circuits/tree/main) such as grayscaling, resizing, and cropping contain a few similar constraints that might be able to improve using recursive SNARK.

**Next step:**
1. Compile image post-processing circuits into Nova prover by [Nova Scotia](https://github.com/nalinbhardwaj/Nova-Scotia).
2. Run [Nova](https://github.com/microsoft/Nova) and test the performances with the benchmarks in the papers. Construct a comparison table among existed protocols.
3. Study on the choices of hash function. I will continue the study on which combinations of them (e.g. Poseidon Hash + Lattice Hash) best fit the recursive SNARK.


### :dart: Milestones

| Status | Milestone | Objective | Tasks | Duration|
|-----------|-----------|-------|----------|--------|
| :fast_forward:| Understanding and Preliminary Research | Gain a comprehensive understanding of current image authentication methods and their limitations. | Literature review and analysis of existing systems. | 2 weeks |
| :fast_forward: | Theoretical Framework Development | Develop a theoretical framework for image authentication using Zero-Knowledge Proof. | Formulating the theoretical aspects of using PCD for image authentication and defining permissible image transformations. | 3 weeks |
| :fast_forward: | Prototype Development | Create a working prototype that demonstrates the practical application of the theoretical framework. | Designing and implementing a prototype that supports a set of permissible transformations. | 4 weeks |
| :fast_forward: | Testing and Evaluation | Rigorously test the prototype for various real-world scenarios and evaluate its performance. | Conducting comprehensive testing and evaluating the prototype’s efficiency with benchmarks. | 3 weeks |
| :fast_forward: | Finalization and Documentation | Finalize the prototype based on testing feedback and prepare comprehensive documentation. | Refining the prototype and preparing documentation and user manuals. | 2 weeks |


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
