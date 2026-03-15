import { ae1 } from "./ae-1";
import { ae2 } from "./ae-2";
import { ae3 } from "./ae-3";
import { si1 } from "./si-1";
import { si2 } from "./si-2";
import { Exam } from "../exam-types";

export const exams: Record<string, Exam> = {
    "ae-1": ae1,
    "ae-2": ae2,
    "ae-3": ae3,
    "si-1": si1,
    "si-2": si2,
};

export const examList: Exam[] = [ae1, ae2, ae3, si1, si2];