import prisma from "@/lib/prisma";
import { ModelCost } from "@prisma/client";

export async function getModelCost(provider: string, model: string): Promise<ModelCost> {
  const currentDate = new Date();

  if (provider.toLowerCase() === "ollama") {
    return {
      id: "ollama",
      provider,
      model,
      inputTokenCost: 0,
      outputTokenCost: 0,
      validFrom: null,
      validTo: null,
    };
  }

  const modelCost = await prisma.modelCost.findFirst({
    where: {
      provider,
      model,
      AND: [
        { OR: [{ validFrom: null }, { validFrom: { lte: currentDate } }] },
        { OR: [{ validTo: null }, { validTo: { gte: currentDate } }] },
      ],
    },
    orderBy: { validFrom: "desc" },
  });

  if (!modelCost) {
    throw new Error(`No cost data found for ${provider} ${model}`);
  }

  return modelCost;
}

export function calculateCost(
  inputTokens: number,
  outputTokens: number,
  modelCost: { inputTokenCost: number; outputTokenCost: number },
) {
  return (
    (inputTokens / 1000000) * modelCost.inputTokenCost +
    (outputTokens / 1000000) * modelCost.outputTokenCost
  );
}
