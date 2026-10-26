# Pràctiques Cloud Computing - INS Provençana

**Alumne:** Laia Bola Simó  
**Curs:** 2026-2027  
**Grup:** ASIX2  
**Mòdul:** Mòdul OPT: Cloud Computing  
**Professors:** Pedro Durán i Joan Muñoz  

---

## Contingut del repositori

Aquest repositori conté el lliurament dels exercicis corresponents a la pràctica **Pt1.4: Iniciació a Terraform i segmentació de xarxes a AWS**:

1. [Exercici 1: Primeres instàncies EC2 amb Terraform (pt1-4-ex1)](./pt1-4-ex1/README.md)
   - Desplegament de 2 instàncies EC2 `t3.micro` amb Amazon Linux 2023 a la regió `us-east-1` mitjançant Terraform (IaC).
   - Diagrama de topologia de xarxa draw.io oficial.
   - Documentació pas a pas del cicle de vida (`init`, `plan`, `apply`, `destroy`).

2. [Exercici 2: Disseny i Desplegament de VPC, Subxarxes i EC2 (pt1-4-ex2)](./pt1-4-ex2/README.md)
   - Disseny d'una VPC personalitzada (`10.0.0.0/16`) i 3 subxarxes a la mateixa Zona de Disponibilitat (`us-east-1a`):
     - Subnet A: `10.0.32.0/25`
     - Subnet B: `10.0.30.0/23`
     - Subnet C: `10.0.33.0/28`
   - Desplegament de 2 instàncies EC2 per subxarxa (total de 6 instàncies `t3.micro` amb Amazon Linux 2023).
   - Desplegament manual per consola d'AWS (GUI) amb captures de pantalla (`vpc_subnets.png`, `ec2_instances.png`).
   - Desplegament automatitzat amb Terraform modularitzat (`main.tf`, `variables.tf`, `outputs.tf`).
   - Diagrama de topologia complet draw.io amb iconografia oficial d'AWS.
